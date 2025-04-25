#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


int
sys_pgpte(void)
{
  uint64 va;
  struct proc *p;  

  p = myproc();
  argaddr(0, &va);
  pte_t *pte = pgpte(p->pagetable, va);
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
}

int
sys_kpgtbl(void)
{
  struct proc *p;  

  p = myproc();
  vmprint(p->pagetable);
  return 0;
}


uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64 
sys_vmprint(void) {
    uint64 pgtbl_addr;
    argaddr(0, &pgtbl_addr);  // Get argument from user space
    vmprint((pagetable_t)pgtbl_addr);  // Call function in vm.c
    return 0;
}

uint64 sys_pgaccess(void) {
  uint64 start_va, mask_user;
  uint64 numpages;

  argaddr(0, &start_va);
  argaddr(1, &numpages);
  argaddr(2, &mask_user);
  
  // Parse system call arguments.
  if (start_va < 0 || numpages < 0 || mask_user < 0)
    return -1;

  struct proc *p = myproc();
  uint64 accessed_mask = 0; // Bitmask that will be returned.

  // For each page in the range.
  for (int i = 0; i < numpages; i++) {
      uint64 va = start_va + i * PGSIZE; // PGSIZE is defined in memlayout.h
      // Get the pointer to the page table entry without allocating a new one.
      pte_t *pte = walk(p->pagetable, va, 0);
      if(pte == 0) {
          // If there's no mapping, leave the bit 0.
          continue;
      }
      // If the access bit (PTE_A) is set, mark it in our mask.
      if(*pte & PTE_A) {
          accessed_mask |= (1ULL << i);
          // Clear the access bit for future calls.
          *pte &= ~PTE_A;
      }
  }
  // Copy the result bitmask to the user-provided address.
  if(copyout(p->pagetable, mask_user, (char *)&accessed_mask, sizeof(accessed_mask)) < 0) {
      return -1;
  }
  return 0;
}

