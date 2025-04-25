
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	46013103          	ld	sp,1120(sp) # 8000a460 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6c7040ef          	jal	80004edc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	7b078793          	addi	a5,a5,1968 # 800237e0 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	46490913          	addi	s2,s2,1124 # 8000a4b0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	0ef050ef          	jal	80005944 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	173050ef          	jal	800059d8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	598050ef          	jal	80005616 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	89be                	mv	s3,a5
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	3d650513          	addi	a0,a0,982 # 8000a4b0 <kmem>
    800000e2:	7de050ef          	jal	800058c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	6f650513          	addi	a0,a0,1782 # 800237e0 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	3a848493          	addi	s1,s1,936 # 8000a4b0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	033050ef          	jal	80005944 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	39450513          	addi	a0,a0,916 # 8000a4b0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	0b3050ef          	jal	800059d8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	37050513          	addi	a0,a0,880 # 8000a4b0 <kmem>
    80000148:	091050ef          	jal	800059d8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000156:	ca19                	beqz	a2,8000016c <memset+0x1e>
    80000158:	87aa                	mv	a5,a0
    8000015a:	1602                	slli	a2,a2,0x20
    8000015c:	9201                	srli	a2,a2,0x20
    8000015e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x14>
  }
  return dst;
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e406                	sd	ra,8(sp)
    80000178:	e022                	sd	s0,0(sp)
    8000017a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000017c:	ca0d                	beqz	a2,800001ae <memcmp+0x3a>
    8000017e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000182:	1682                	slli	a3,a3,0x20
    80000184:	9281                	srli	a3,a3,0x20
    80000186:	0685                	addi	a3,a3,1
    80000188:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000018a:	00054783          	lbu	a5,0(a0)
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	00e79863          	bne	a5,a4,800001a2 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000196:	0505                	addi	a0,a0,1
    80000198:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000019a:	fed518e3          	bne	a0,a3,8000018a <memcmp+0x16>
  }

  return 0;
    8000019e:	4501                	li	a0,0
    800001a0:	a019                	j	800001a6 <memcmp+0x32>
      return *s1 - *s2;
    800001a2:	40e7853b          	subw	a0,a5,a4
}
    800001a6:	60a2                	ld	ra,8(sp)
    800001a8:	6402                	ld	s0,0(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret
  return 0;
    800001ae:	4501                	li	a0,0
    800001b0:	bfdd                	j	800001a6 <memcmp+0x32>

00000000800001b2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ba:	c205                	beqz	a2,800001da <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001bc:	02a5e363          	bltu	a1,a0,800001e2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c0:	1602                	slli	a2,a2,0x20
    800001c2:	9201                	srli	a2,a2,0x20
    800001c4:	00c587b3          	add	a5,a1,a2
{
    800001c8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ca:	0585                	addi	a1,a1,1
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb821>
    800001ce:	fff5c683          	lbu	a3,-1(a1)
    800001d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001d6:	feb79ae3          	bne	a5,a1,800001ca <memmove+0x18>

  return dst;
}
    800001da:	60a2                	ld	ra,8(sp)
    800001dc:	6402                	ld	s0,0(sp)
    800001de:	0141                	addi	sp,sp,16
    800001e0:	8082                	ret
  if(s < d && s + n > d){
    800001e2:	02061693          	slli	a3,a2,0x20
    800001e6:	9281                	srli	a3,a3,0x20
    800001e8:	00d58733          	add	a4,a1,a3
    800001ec:	fce57ae3          	bgeu	a0,a4,800001c0 <memmove+0xe>
    d += n;
    800001f0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	fff7c793          	not	a5,a5
    800001fe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000200:	177d                	addi	a4,a4,-1
    80000202:	16fd                	addi	a3,a3,-1
    80000204:	00074603          	lbu	a2,0(a4)
    80000208:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000020c:	fee79ae3          	bne	a5,a4,80000200 <memmove+0x4e>
    80000210:	b7e9                	j	800001da <memmove+0x28>

0000000080000212 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000021a:	f99ff0ef          	jal	800001b2 <memmove>
}
    8000021e:	60a2                	ld	ra,8(sp)
    80000220:	6402                	ld	s0,0(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret

0000000080000226 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000022e:	ce11                	beqz	a2,8000024a <strncmp+0x24>
    80000230:	00054783          	lbu	a5,0(a0)
    80000234:	cf89                	beqz	a5,8000024e <strncmp+0x28>
    80000236:	0005c703          	lbu	a4,0(a1)
    8000023a:	00f71a63          	bne	a4,a5,8000024e <strncmp+0x28>
    n--, p++, q++;
    8000023e:	367d                	addiw	a2,a2,-1
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000244:	f675                	bnez	a2,80000230 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000246:	4501                	li	a0,0
    80000248:	a801                	j	80000258 <strncmp+0x32>
    8000024a:	4501                	li	a0,0
    8000024c:	a031                	j	80000258 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000024e:	00054503          	lbu	a0,0(a0)
    80000252:	0005c783          	lbu	a5,0(a1)
    80000256:	9d1d                	subw	a0,a0,a5
}
    80000258:	60a2                	ld	ra,8(sp)
    8000025a:	6402                	ld	s0,0(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret

0000000080000260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000260:	1141                	addi	sp,sp,-16
    80000262:	e406                	sd	ra,8(sp)
    80000264:	e022                	sd	s0,0(sp)
    80000266:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000268:	87aa                	mv	a5,a0
    8000026a:	86b2                	mv	a3,a2
    8000026c:	367d                	addiw	a2,a2,-1
    8000026e:	02d05563          	blez	a3,80000298 <strncpy+0x38>
    80000272:	0785                	addi	a5,a5,1
    80000274:	0005c703          	lbu	a4,0(a1)
    80000278:	fee78fa3          	sb	a4,-1(a5)
    8000027c:	0585                	addi	a1,a1,1
    8000027e:	f775                	bnez	a4,8000026a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000280:	873e                	mv	a4,a5
    80000282:	00c05b63          	blez	a2,80000298 <strncpy+0x38>
    80000286:	9fb5                	addw	a5,a5,a3
    80000288:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000028a:	0705                	addi	a4,a4,1
    8000028c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000290:	40e786bb          	subw	a3,a5,a4
    80000294:	fed04be3          	bgtz	a3,8000028a <strncpy+0x2a>
  return os;
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a8:	02c05363          	blez	a2,800002ce <safestrcpy+0x2e>
    800002ac:	fff6069b          	addiw	a3,a2,-1
    800002b0:	1682                	slli	a3,a3,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	96ae                	add	a3,a3,a1
    800002b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b8:	00d58963          	beq	a1,a3,800002ca <safestrcpy+0x2a>
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0785                	addi	a5,a5,1
    800002c0:	fff5c703          	lbu	a4,-1(a1)
    800002c4:	fee78fa3          	sb	a4,-1(a5)
    800002c8:	fb65                	bnez	a4,800002b8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ce:	60a2                	ld	ra,8(sp)
    800002d0:	6402                	ld	s0,0(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret

00000000800002d6 <strlen>:

int
strlen(const char *s)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002de:	00054783          	lbu	a5,0(a0)
    800002e2:	cf99                	beqz	a5,80000300 <strlen+0x2a>
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	87aa                	mv	a5,a0
    800002e8:	86be                	mv	a3,a5
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff7c703          	lbu	a4,-1(a5)
    800002f0:	ff65                	bnez	a4,800002e8 <strlen+0x12>
    800002f2:	40a6853b          	subw	a0,a3,a0
    800002f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <strlen+0x22>

0000000080000304 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000030c:	319000ef          	jal	80000e24 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000310:	0000a717          	auipc	a4,0xa
    80000314:	17070713          	addi	a4,a4,368 # 8000a480 <started>
  if(cpuid() == 0){
    80000318:	c51d                	beqz	a0,80000346 <main+0x42>
    while(started == 0)
    8000031a:	431c                	lw	a5,0(a4)
    8000031c:	2781                	sext.w	a5,a5
    8000031e:	dff5                	beqz	a5,8000031a <main+0x16>
      ;
    __sync_synchronize();
    80000320:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000324:	301000ef          	jal	80000e24 <cpuid>
    80000328:	85aa                	mv	a1,a0
    8000032a:	00007517          	auipc	a0,0x7
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80007038 <etext+0x38>
    80000332:	014050ef          	jal	80005346 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	608010ef          	jal	80001942 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	5ea040ef          	jal	80004928 <plicinithart>
  }

  scheduler();        
    80000342:	74b000ef          	jal	8000128c <scheduler>
    consoleinit();
    80000346:	733040ef          	jal	80005278 <consoleinit>
    printfinit();
    8000034a:	306050ef          	jal	80005650 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	7f1040ef          	jal	80005346 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	7e5040ef          	jal	80005346 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	7d9040ef          	jal	80005346 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2d8000ef          	jal	8000064e <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	1f9000ef          	jal	80000d76 <procinit>
    trapinit();      // trap vectors
    80000382:	59c010ef          	jal	8000191e <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	5bc010ef          	jal	80001942 <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	584040ef          	jal	8000490e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	59a040ef          	jal	80004928 <plicinithart>
    binit();         // buffer cache
    80000392:	4fb010ef          	jal	8000208c <binit>
    iinit();         // inode table
    80000396:	2c6020ef          	jal	8000265c <iinit>
    fileinit();      // file table
    8000039a:	094030ef          	jal	8000342e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	67a040ef          	jal	80004a18 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	51f000ef          	jal	800010c0 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	0000a717          	auipc	a4,0xa
    800003b0:	0cf72a23          	sw	a5,212(a4) # 8000a480 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003be:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003c2:	0000a797          	auipc	a5,0xa
    800003c6:	0c67b783          	ld	a5,198(a5) # 8000a488 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003d2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003d6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003e2:	7139                	addi	sp,sp,-64
    800003e4:	fc06                	sd	ra,56(sp)
    800003e6:	f822                	sd	s0,48(sp)
    800003e8:	f426                	sd	s1,40(sp)
    800003ea:	f04a                	sd	s2,32(sp)
    800003ec:	ec4e                	sd	s3,24(sp)
    800003ee:	e852                	sd	s4,16(sp)
    800003f0:	e456                	sd	s5,8(sp)
    800003f2:	e05a                	sd	s6,0(sp)
    800003f4:	0080                	addi	s0,sp,64
    800003f6:	892a                	mv	s2,a0
    800003f8:	89ae                	mv	s3,a1
    800003fa:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000402:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000404:	04b7e663          	bltu	a5,a1,80000450 <walk+0x6e>
    pte_t *pte = &pagetable[PX(level, va)];
    80000408:	0149d4b3          	srl	s1,s3,s4
    8000040c:	1ff4f493          	andi	s1,s1,511
    80000410:	048e                	slli	s1,s1,0x3
    80000412:	94ca                	add	s1,s1,s2
    if(*pte & PTE_V) {
    80000414:	609c                	ld	a5,0(s1)
    80000416:	0017f713          	andi	a4,a5,1
    8000041a:	c329                	beqz	a4,8000045c <walk+0x7a>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000041c:	00a7d913          	srli	s2,a5,0xa
    80000420:	0932                	slli	s2,s2,0xc
#ifdef LAB_PGTBL
      if(PTE_LEAF(*pte)) {
    80000422:	8bb9                	andi	a5,a5,14
    80000424:	eb99                	bnez	a5,8000043a <walk+0x58>
  for(int level = 2; level > 0; level--) {
    80000426:	3a5d                	addiw	s4,s4,-9
    80000428:	ff6a10e3          	bne	s4,s6,80000408 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000042c:	00c9d993          	srli	s3,s3,0xc
    80000430:	1ff9f993          	andi	s3,s3,511
    80000434:	098e                	slli	s3,s3,0x3
    80000436:	013904b3          	add	s1,s2,s3
}
    8000043a:	8526                	mv	a0,s1
    8000043c:	70e2                	ld	ra,56(sp)
    8000043e:	7442                	ld	s0,48(sp)
    80000440:	74a2                	ld	s1,40(sp)
    80000442:	7902                	ld	s2,32(sp)
    80000444:	69e2                	ld	s3,24(sp)
    80000446:	6a42                	ld	s4,16(sp)
    80000448:	6aa2                	ld	s5,8(sp)
    8000044a:	6b02                	ld	s6,0(sp)
    8000044c:	6121                	addi	sp,sp,64
    8000044e:	8082                	ret
    panic("walk");
    80000450:	00007517          	auipc	a0,0x7
    80000454:	c0050513          	addi	a0,a0,-1024 # 80007050 <etext+0x50>
    80000458:	1be050ef          	jal	80005616 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000045c:	020a8163          	beqz	s5,8000047e <walk+0x9c>
    80000460:	c9fff0ef          	jal	800000fe <kalloc>
    80000464:	892a                	mv	s2,a0
    80000466:	cd11                	beqz	a0,80000482 <walk+0xa0>
      memset(pagetable, 0, PGSIZE);
    80000468:	6605                	lui	a2,0x1
    8000046a:	4581                	li	a1,0
    8000046c:	ce3ff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000470:	00c95793          	srli	a5,s2,0xc
    80000474:	07aa                	slli	a5,a5,0xa
    80000476:	0017e793          	ori	a5,a5,1
    8000047a:	e09c                	sd	a5,0(s1)
    8000047c:	b76d                	j	80000426 <walk+0x44>
        return 0;
    8000047e:	4481                	li	s1,0
    80000480:	bf6d                	j	8000043a <walk+0x58>
    80000482:	84aa                	mv	s1,a0
    80000484:	bf5d                	j	8000043a <walk+0x58>

0000000080000486 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000486:	57fd                	li	a5,-1
    80000488:	83e9                	srli	a5,a5,0x1a
    8000048a:	00b7f463          	bgeu	a5,a1,80000492 <walkaddr+0xc>
    return 0;
    8000048e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000490:	8082                	ret
{
    80000492:	1141                	addi	sp,sp,-16
    80000494:	e406                	sd	ra,8(sp)
    80000496:	e022                	sd	s0,0(sp)
    80000498:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000049a:	4601                	li	a2,0
    8000049c:	f47ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    800004a0:	c105                	beqz	a0,800004c0 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004a2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004a4:	0117f693          	andi	a3,a5,17
    800004a8:	4745                	li	a4,17
    return 0;
    800004aa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004ac:	00e68663          	beq	a3,a4,800004b8 <walkaddr+0x32>
}
    800004b0:	60a2                	ld	ra,8(sp)
    800004b2:	6402                	ld	s0,0(sp)
    800004b4:	0141                	addi	sp,sp,16
    800004b6:	8082                	ret
  pa = PTE2PA(*pte);
    800004b8:	83a9                	srli	a5,a5,0xa
    800004ba:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004be:	bfcd                	j	800004b0 <walkaddr+0x2a>
    return 0;
    800004c0:	4501                	li	a0,0
    800004c2:	b7fd                	j	800004b0 <walkaddr+0x2a>

00000000800004c4 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c4:	715d                	addi	sp,sp,-80
    800004c6:	e486                	sd	ra,72(sp)
    800004c8:	e0a2                	sd	s0,64(sp)
    800004ca:	fc26                	sd	s1,56(sp)
    800004cc:	f84a                	sd	s2,48(sp)
    800004ce:	f44e                	sd	s3,40(sp)
    800004d0:	f052                	sd	s4,32(sp)
    800004d2:	ec56                	sd	s5,24(sp)
    800004d4:	e85a                	sd	s6,16(sp)
    800004d6:	e45e                	sd	s7,8(sp)
    800004d8:	e062                	sd	s8,0(sp)
    800004da:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004dc:	03459793          	slli	a5,a1,0x34
    800004e0:	e7b1                	bnez	a5,8000052c <mappages+0x68>
    800004e2:	8aaa                	mv	s5,a0
    800004e4:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e6:	03461793          	slli	a5,a2,0x34
    800004ea:	e7b9                	bnez	a5,80000538 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ec:	ce21                	beqz	a2,80000544 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ee:	77fd                	lui	a5,0xfffff
    800004f0:	963e                	add	a2,a2,a5
    800004f2:	00b609b3          	add	s3,a2,a1
  a = va;
    800004f6:	892e                	mv	s2,a1
    800004f8:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004fe:	6c05                	lui	s8,0x1
    80000500:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000504:	865e                	mv	a2,s7
    80000506:	85ca                	mv	a1,s2
    80000508:	8556                	mv	a0,s5
    8000050a:	ed9ff0ef          	jal	800003e2 <walk>
    8000050e:	c539                	beqz	a0,8000055c <mappages+0x98>
    if(*pte & PTE_V)
    80000510:	611c                	ld	a5,0(a0)
    80000512:	8b85                	andi	a5,a5,1
    80000514:	ef95                	bnez	a5,80000550 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000516:	80b1                	srli	s1,s1,0xc
    80000518:	04aa                	slli	s1,s1,0xa
    8000051a:	0164e4b3          	or	s1,s1,s6
    8000051e:	0014e493          	ori	s1,s1,1
    80000522:	e104                	sd	s1,0(a0)
    if(a == last)
    80000524:	05390963          	beq	s2,s3,80000576 <mappages+0xb2>
    a += PGSIZE;
    80000528:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    8000052a:	bfd9                	j	80000500 <mappages+0x3c>
    panic("mappages: va not aligned");
    8000052c:	00007517          	auipc	a0,0x7
    80000530:	b2c50513          	addi	a0,a0,-1236 # 80007058 <etext+0x58>
    80000534:	0e2050ef          	jal	80005616 <panic>
    panic("mappages: size not aligned");
    80000538:	00007517          	auipc	a0,0x7
    8000053c:	b4050513          	addi	a0,a0,-1216 # 80007078 <etext+0x78>
    80000540:	0d6050ef          	jal	80005616 <panic>
    panic("mappages: size");
    80000544:	00007517          	auipc	a0,0x7
    80000548:	b5450513          	addi	a0,a0,-1196 # 80007098 <etext+0x98>
    8000054c:	0ca050ef          	jal	80005616 <panic>
      panic("mappages: remap");
    80000550:	00007517          	auipc	a0,0x7
    80000554:	b5850513          	addi	a0,a0,-1192 # 800070a8 <etext+0xa8>
    80000558:	0be050ef          	jal	80005616 <panic>
      return -1;
    8000055c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000055e:	60a6                	ld	ra,72(sp)
    80000560:	6406                	ld	s0,64(sp)
    80000562:	74e2                	ld	s1,56(sp)
    80000564:	7942                	ld	s2,48(sp)
    80000566:	79a2                	ld	s3,40(sp)
    80000568:	7a02                	ld	s4,32(sp)
    8000056a:	6ae2                	ld	s5,24(sp)
    8000056c:	6b42                	ld	s6,16(sp)
    8000056e:	6ba2                	ld	s7,8(sp)
    80000570:	6c02                	ld	s8,0(sp)
    80000572:	6161                	addi	sp,sp,80
    80000574:	8082                	ret
  return 0;
    80000576:	4501                	li	a0,0
    80000578:	b7dd                	j	8000055e <mappages+0x9a>

000000008000057a <kvmmap>:
{
    8000057a:	1141                	addi	sp,sp,-16
    8000057c:	e406                	sd	ra,8(sp)
    8000057e:	e022                	sd	s0,0(sp)
    80000580:	0800                	addi	s0,sp,16
    80000582:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000584:	86b2                	mv	a3,a2
    80000586:	863e                	mv	a2,a5
    80000588:	f3dff0ef          	jal	800004c4 <mappages>
    8000058c:	e509                	bnez	a0,80000596 <kvmmap+0x1c>
}
    8000058e:	60a2                	ld	ra,8(sp)
    80000590:	6402                	ld	s0,0(sp)
    80000592:	0141                	addi	sp,sp,16
    80000594:	8082                	ret
    panic("kvmmap");
    80000596:	00007517          	auipc	a0,0x7
    8000059a:	b2250513          	addi	a0,a0,-1246 # 800070b8 <etext+0xb8>
    8000059e:	078050ef          	jal	80005616 <panic>

00000000800005a2 <kvmmake>:
{
    800005a2:	1101                	addi	sp,sp,-32
    800005a4:	ec06                	sd	ra,24(sp)
    800005a6:	e822                	sd	s0,16(sp)
    800005a8:	e426                	sd	s1,8(sp)
    800005aa:	e04a                	sd	s2,0(sp)
    800005ac:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005ae:	b51ff0ef          	jal	800000fe <kalloc>
    800005b2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005b4:	6605                	lui	a2,0x1
    800005b6:	4581                	li	a1,0
    800005b8:	b97ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005bc:	4719                	li	a4,6
    800005be:	6685                	lui	a3,0x1
    800005c0:	10000637          	lui	a2,0x10000
    800005c4:	85b2                	mv	a1,a2
    800005c6:	8526                	mv	a0,s1
    800005c8:	fb3ff0ef          	jal	8000057a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005cc:	4719                	li	a4,6
    800005ce:	6685                	lui	a3,0x1
    800005d0:	10001637          	lui	a2,0x10001
    800005d4:	85b2                	mv	a1,a2
    800005d6:	8526                	mv	a0,s1
    800005d8:	fa3ff0ef          	jal	8000057a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005dc:	4719                	li	a4,6
    800005de:	040006b7          	lui	a3,0x4000
    800005e2:	0c000637          	lui	a2,0xc000
    800005e6:	85b2                	mv	a1,a2
    800005e8:	8526                	mv	a0,s1
    800005ea:	f91ff0ef          	jal	8000057a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ee:	00007917          	auipc	s2,0x7
    800005f2:	a1290913          	addi	s2,s2,-1518 # 80007000 <etext>
    800005f6:	4729                	li	a4,10
    800005f8:	80007697          	auipc	a3,0x80007
    800005fc:	a0868693          	addi	a3,a3,-1528 # 7000 <_entry-0x7fff9000>
    80000600:	4605                	li	a2,1
    80000602:	067e                	slli	a2,a2,0x1f
    80000604:	85b2                	mv	a1,a2
    80000606:	8526                	mv	a0,s1
    80000608:	f73ff0ef          	jal	8000057a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000060c:	4719                	li	a4,6
    8000060e:	46c5                	li	a3,17
    80000610:	06ee                	slli	a3,a3,0x1b
    80000612:	412686b3          	sub	a3,a3,s2
    80000616:	864a                	mv	a2,s2
    80000618:	85ca                	mv	a1,s2
    8000061a:	8526                	mv	a0,s1
    8000061c:	f5fff0ef          	jal	8000057a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000620:	4729                	li	a4,10
    80000622:	6685                	lui	a3,0x1
    80000624:	00006617          	auipc	a2,0x6
    80000628:	9dc60613          	addi	a2,a2,-1572 # 80006000 <_trampoline>
    8000062c:	040005b7          	lui	a1,0x4000
    80000630:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000632:	05b2                	slli	a1,a1,0xc
    80000634:	8526                	mv	a0,s1
    80000636:	f45ff0ef          	jal	8000057a <kvmmap>
  proc_mapstacks(kpgtbl);
    8000063a:	8526                	mv	a0,s1
    8000063c:	69e000ef          	jal	80000cda <proc_mapstacks>
}
    80000640:	8526                	mv	a0,s1
    80000642:	60e2                	ld	ra,24(sp)
    80000644:	6442                	ld	s0,16(sp)
    80000646:	64a2                	ld	s1,8(sp)
    80000648:	6902                	ld	s2,0(sp)
    8000064a:	6105                	addi	sp,sp,32
    8000064c:	8082                	ret

000000008000064e <kvminit>:
{
    8000064e:	1141                	addi	sp,sp,-16
    80000650:	e406                	sd	ra,8(sp)
    80000652:	e022                	sd	s0,0(sp)
    80000654:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000656:	f4dff0ef          	jal	800005a2 <kvmmake>
    8000065a:	0000a797          	auipc	a5,0xa
    8000065e:	e2a7b723          	sd	a0,-466(a5) # 8000a488 <kernel_pagetable>
}
    80000662:	60a2                	ld	ra,8(sp)
    80000664:	6402                	ld	s0,0(sp)
    80000666:	0141                	addi	sp,sp,16
    80000668:	8082                	ret

000000008000066a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000066a:	715d                	addi	sp,sp,-80
    8000066c:	e486                	sd	ra,72(sp)
    8000066e:	e0a2                	sd	s0,64(sp)
    80000670:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000672:	03459793          	slli	a5,a1,0x34
    80000676:	e39d                	bnez	a5,8000069c <uvmunmap+0x32>
    80000678:	f84a                	sd	s2,48(sp)
    8000067a:	f44e                	sd	s3,40(sp)
    8000067c:	f052                	sd	s4,32(sp)
    8000067e:	ec56                	sd	s5,24(sp)
    80000680:	e85a                	sd	s6,16(sp)
    80000682:	e45e                	sd	s7,8(sp)
    80000684:	8a2a                	mv	s4,a0
    80000686:	892e                	mv	s2,a1
    80000688:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000068a:	0632                	slli	a2,a2,0xc
    8000068c:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000690:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000692:	6b05                	lui	s6,0x1
    80000694:	0935f763          	bgeu	a1,s3,80000722 <uvmunmap+0xb8>
    80000698:	fc26                	sd	s1,56(sp)
    8000069a:	a8a1                	j	800006f2 <uvmunmap+0x88>
    8000069c:	fc26                	sd	s1,56(sp)
    8000069e:	f84a                	sd	s2,48(sp)
    800006a0:	f44e                	sd	s3,40(sp)
    800006a2:	f052                	sd	s4,32(sp)
    800006a4:	ec56                	sd	s5,24(sp)
    800006a6:	e85a                	sd	s6,16(sp)
    800006a8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006aa:	00007517          	auipc	a0,0x7
    800006ae:	a1650513          	addi	a0,a0,-1514 # 800070c0 <etext+0xc0>
    800006b2:	765040ef          	jal	80005616 <panic>
      panic("uvmunmap: walk");
    800006b6:	00007517          	auipc	a0,0x7
    800006ba:	a2250513          	addi	a0,a0,-1502 # 800070d8 <etext+0xd8>
    800006be:	759040ef          	jal	80005616 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006c2:	85ca                	mv	a1,s2
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a2450513          	addi	a0,a0,-1500 # 800070e8 <etext+0xe8>
    800006cc:	47b040ef          	jal	80005346 <printf>
      panic("uvmunmap: not mapped");
    800006d0:	00007517          	auipc	a0,0x7
    800006d4:	a2850513          	addi	a0,a0,-1496 # 800070f8 <etext+0xf8>
    800006d8:	73f040ef          	jal	80005616 <panic>
      panic("uvmunmap: not a leaf");
    800006dc:	00007517          	auipc	a0,0x7
    800006e0:	a3450513          	addi	a0,a0,-1484 # 80007110 <etext+0x110>
    800006e4:	733040ef          	jal	80005616 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006e8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006ec:	995a                	add	s2,s2,s6
    800006ee:	03397963          	bgeu	s2,s3,80000720 <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006f2:	4601                	li	a2,0
    800006f4:	85ca                	mv	a1,s2
    800006f6:	8552                	mv	a0,s4
    800006f8:	cebff0ef          	jal	800003e2 <walk>
    800006fc:	84aa                	mv	s1,a0
    800006fe:	dd45                	beqz	a0,800006b6 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    80000700:	6110                	ld	a2,0(a0)
    80000702:	00167793          	andi	a5,a2,1
    80000706:	dfd5                	beqz	a5,800006c2 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000708:	3ff67793          	andi	a5,a2,1023
    8000070c:	fd7788e3          	beq	a5,s7,800006dc <uvmunmap+0x72>
    if(do_free){
    80000710:	fc0a8ce3          	beqz	s5,800006e8 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    80000714:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80000716:	00c61513          	slli	a0,a2,0xc
    8000071a:	903ff0ef          	jal	8000001c <kfree>
    8000071e:	b7e9                	j	800006e8 <uvmunmap+0x7e>
    80000720:	74e2                	ld	s1,56(sp)
    80000722:	7942                	ld	s2,48(sp)
    80000724:	79a2                	ld	s3,40(sp)
    80000726:	7a02                	ld	s4,32(sp)
    80000728:	6ae2                	ld	s5,24(sp)
    8000072a:	6b42                	ld	s6,16(sp)
    8000072c:	6ba2                	ld	s7,8(sp)
  }
}
    8000072e:	60a6                	ld	ra,72(sp)
    80000730:	6406                	ld	s0,64(sp)
    80000732:	6161                	addi	sp,sp,80
    80000734:	8082                	ret

0000000080000736 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000736:	1101                	addi	sp,sp,-32
    80000738:	ec06                	sd	ra,24(sp)
    8000073a:	e822                	sd	s0,16(sp)
    8000073c:	e426                	sd	s1,8(sp)
    8000073e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000740:	9bfff0ef          	jal	800000fe <kalloc>
    80000744:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000746:	c509                	beqz	a0,80000750 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000748:	6605                	lui	a2,0x1
    8000074a:	4581                	li	a1,0
    8000074c:	a03ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000750:	8526                	mv	a0,s1
    80000752:	60e2                	ld	ra,24(sp)
    80000754:	6442                	ld	s0,16(sp)
    80000756:	64a2                	ld	s1,8(sp)
    80000758:	6105                	addi	sp,sp,32
    8000075a:	8082                	ret

000000008000075c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000075c:	7179                	addi	sp,sp,-48
    8000075e:	f406                	sd	ra,40(sp)
    80000760:	f022                	sd	s0,32(sp)
    80000762:	ec26                	sd	s1,24(sp)
    80000764:	e84a                	sd	s2,16(sp)
    80000766:	e44e                	sd	s3,8(sp)
    80000768:	e052                	sd	s4,0(sp)
    8000076a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000076c:	6785                	lui	a5,0x1
    8000076e:	04f67063          	bgeu	a2,a5,800007ae <uvmfirst+0x52>
    80000772:	8a2a                	mv	s4,a0
    80000774:	89ae                	mv	s3,a1
    80000776:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000778:	987ff0ef          	jal	800000fe <kalloc>
    8000077c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000077e:	6605                	lui	a2,0x1
    80000780:	4581                	li	a1,0
    80000782:	9cdff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000786:	4779                	li	a4,30
    80000788:	86ca                	mv	a3,s2
    8000078a:	6605                	lui	a2,0x1
    8000078c:	4581                	li	a1,0
    8000078e:	8552                	mv	a0,s4
    80000790:	d35ff0ef          	jal	800004c4 <mappages>
  memmove(mem, src, sz);
    80000794:	8626                	mv	a2,s1
    80000796:	85ce                	mv	a1,s3
    80000798:	854a                	mv	a0,s2
    8000079a:	a19ff0ef          	jal	800001b2 <memmove>
}
    8000079e:	70a2                	ld	ra,40(sp)
    800007a0:	7402                	ld	s0,32(sp)
    800007a2:	64e2                	ld	s1,24(sp)
    800007a4:	6942                	ld	s2,16(sp)
    800007a6:	69a2                	ld	s3,8(sp)
    800007a8:	6a02                	ld	s4,0(sp)
    800007aa:	6145                	addi	sp,sp,48
    800007ac:	8082                	ret
    panic("uvmfirst: more than a page");
    800007ae:	00007517          	auipc	a0,0x7
    800007b2:	97a50513          	addi	a0,a0,-1670 # 80007128 <etext+0x128>
    800007b6:	661040ef          	jal	80005616 <panic>

00000000800007ba <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007ba:	1101                	addi	sp,sp,-32
    800007bc:	ec06                	sd	ra,24(sp)
    800007be:	e822                	sd	s0,16(sp)
    800007c0:	e426                	sd	s1,8(sp)
    800007c2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007c4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007c6:	00b67d63          	bgeu	a2,a1,800007e0 <uvmdealloc+0x26>
    800007ca:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007cc:	6785                	lui	a5,0x1
    800007ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d0:	00f60733          	add	a4,a2,a5
    800007d4:	76fd                	lui	a3,0xfffff
    800007d6:	8f75                	and	a4,a4,a3
    800007d8:	97ae                	add	a5,a5,a1
    800007da:	8ff5                	and	a5,a5,a3
    800007dc:	00f76863          	bltu	a4,a5,800007ec <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007e0:	8526                	mv	a0,s1
    800007e2:	60e2                	ld	ra,24(sp)
    800007e4:	6442                	ld	s0,16(sp)
    800007e6:	64a2                	ld	s1,8(sp)
    800007e8:	6105                	addi	sp,sp,32
    800007ea:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007ec:	8f99                	sub	a5,a5,a4
    800007ee:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007f0:	4685                	li	a3,1
    800007f2:	0007861b          	sext.w	a2,a5
    800007f6:	85ba                	mv	a1,a4
    800007f8:	e73ff0ef          	jal	8000066a <uvmunmap>
    800007fc:	b7d5                	j	800007e0 <uvmdealloc+0x26>

00000000800007fe <uvmalloc>:
  if(newsz < oldsz)
    800007fe:	0ab66363          	bltu	a2,a1,800008a4 <uvmalloc+0xa6>
{
    80000802:	715d                	addi	sp,sp,-80
    80000804:	e486                	sd	ra,72(sp)
    80000806:	e0a2                	sd	s0,64(sp)
    80000808:	f052                	sd	s4,32(sp)
    8000080a:	ec56                	sd	s5,24(sp)
    8000080c:	e85a                	sd	s6,16(sp)
    8000080e:	0880                	addi	s0,sp,80
    80000810:	8b2a                	mv	s6,a0
    80000812:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80000814:	6785                	lui	a5,0x1
    80000816:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000818:	95be                	add	a1,a1,a5
    8000081a:	77fd                	lui	a5,0xfffff
    8000081c:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    80000820:	08ca7463          	bgeu	s4,a2,800008a8 <uvmalloc+0xaa>
    80000824:	fc26                	sd	s1,56(sp)
    80000826:	f84a                	sd	s2,48(sp)
    80000828:	f44e                	sd	s3,40(sp)
    8000082a:	e45e                	sd	s7,8(sp)
    8000082c:	8952                	mv	s2,s4
    memset(mem, 0, sz);
    8000082e:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000830:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    80000834:	8cbff0ef          	jal	800000fe <kalloc>
    80000838:	84aa                	mv	s1,a0
    if(mem == 0){
    8000083a:	c515                	beqz	a0,80000866 <uvmalloc+0x68>
    memset(mem, 0, sz);
    8000083c:	864e                	mv	a2,s3
    8000083e:	4581                	li	a1,0
    80000840:	90fff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000844:	875e                	mv	a4,s7
    80000846:	86a6                	mv	a3,s1
    80000848:	864e                	mv	a2,s3
    8000084a:	85ca                	mv	a1,s2
    8000084c:	855a                	mv	a0,s6
    8000084e:	c77ff0ef          	jal	800004c4 <mappages>
    80000852:	e91d                	bnez	a0,80000888 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += sz){
    80000854:	994e                	add	s2,s2,s3
    80000856:	fd596fe3          	bltu	s2,s5,80000834 <uvmalloc+0x36>
  return newsz;
    8000085a:	8556                	mv	a0,s5
    8000085c:	74e2                	ld	s1,56(sp)
    8000085e:	7942                	ld	s2,48(sp)
    80000860:	79a2                	ld	s3,40(sp)
    80000862:	6ba2                	ld	s7,8(sp)
    80000864:	a819                	j	8000087a <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000866:	8652                	mv	a2,s4
    80000868:	85ca                	mv	a1,s2
    8000086a:	855a                	mv	a0,s6
    8000086c:	f4fff0ef          	jal	800007ba <uvmdealloc>
      return 0;
    80000870:	4501                	li	a0,0
    80000872:	74e2                	ld	s1,56(sp)
    80000874:	7942                	ld	s2,48(sp)
    80000876:	79a2                	ld	s3,40(sp)
    80000878:	6ba2                	ld	s7,8(sp)
}
    8000087a:	60a6                	ld	ra,72(sp)
    8000087c:	6406                	ld	s0,64(sp)
    8000087e:	7a02                	ld	s4,32(sp)
    80000880:	6ae2                	ld	s5,24(sp)
    80000882:	6b42                	ld	s6,16(sp)
    80000884:	6161                	addi	sp,sp,80
    80000886:	8082                	ret
      kfree(mem);
    80000888:	8526                	mv	a0,s1
    8000088a:	f92ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000088e:	8652                	mv	a2,s4
    80000890:	85ca                	mv	a1,s2
    80000892:	855a                	mv	a0,s6
    80000894:	f27ff0ef          	jal	800007ba <uvmdealloc>
      return 0;
    80000898:	4501                	li	a0,0
    8000089a:	74e2                	ld	s1,56(sp)
    8000089c:	7942                	ld	s2,48(sp)
    8000089e:	79a2                	ld	s3,40(sp)
    800008a0:	6ba2                	ld	s7,8(sp)
    800008a2:	bfe1                	j	8000087a <uvmalloc+0x7c>
    return oldsz;
    800008a4:	852e                	mv	a0,a1
}
    800008a6:	8082                	ret
  return newsz;
    800008a8:	8532                	mv	a0,a2
    800008aa:	bfc1                	j	8000087a <uvmalloc+0x7c>

00000000800008ac <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008ac:	7179                	addi	sp,sp,-48
    800008ae:	f406                	sd	ra,40(sp)
    800008b0:	f022                	sd	s0,32(sp)
    800008b2:	ec26                	sd	s1,24(sp)
    800008b4:	e84a                	sd	s2,16(sp)
    800008b6:	e44e                	sd	s3,8(sp)
    800008b8:	e052                	sd	s4,0(sp)
    800008ba:	1800                	addi	s0,sp,48
    800008bc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008be:	84aa                	mv	s1,a0
    800008c0:	6905                	lui	s2,0x1
    800008c2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	4985                	li	s3,1
    800008c6:	a819                	j	800008dc <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008c8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008ca:	00c79513          	slli	a0,a5,0xc
    800008ce:	fdfff0ef          	jal	800008ac <freewalk>
      pagetable[i] = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008d6:	04a1                	addi	s1,s1,8
    800008d8:	01248f63          	beq	s1,s2,800008f6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008de:	00f7f713          	andi	a4,a5,15
    800008e2:	ff3703e3          	beq	a4,s3,800008c8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008e6:	8b85                	andi	a5,a5,1
    800008e8:	d7fd                	beqz	a5,800008d6 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008ea:	00007517          	auipc	a0,0x7
    800008ee:	85e50513          	addi	a0,a0,-1954 # 80007148 <etext+0x148>
    800008f2:	525040ef          	jal	80005616 <panic>
    }
  }
  kfree((void*)pagetable);
    800008f6:	8552                	mv	a0,s4
    800008f8:	f24ff0ef          	jal	8000001c <kfree>
}
    800008fc:	70a2                	ld	ra,40(sp)
    800008fe:	7402                	ld	s0,32(sp)
    80000900:	64e2                	ld	s1,24(sp)
    80000902:	6942                	ld	s2,16(sp)
    80000904:	69a2                	ld	s3,8(sp)
    80000906:	6a02                	ld	s4,0(sp)
    80000908:	6145                	addi	sp,sp,48
    8000090a:	8082                	ret

000000008000090c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
    80000916:	84aa                	mv	s1,a0
  if(sz > 0)
    80000918:	e989                	bnez	a1,8000092a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000091a:	8526                	mv	a0,s1
    8000091c:	f91ff0ef          	jal	800008ac <freewalk>
}
    80000920:	60e2                	ld	ra,24(sp)
    80000922:	6442                	ld	s0,16(sp)
    80000924:	64a2                	ld	s1,8(sp)
    80000926:	6105                	addi	sp,sp,32
    80000928:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000092a:	6785                	lui	a5,0x1
    8000092c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000092e:	95be                	add	a1,a1,a5
    80000930:	4685                	li	a3,1
    80000932:	00c5d613          	srli	a2,a1,0xc
    80000936:	4581                	li	a1,0
    80000938:	d33ff0ef          	jal	8000066a <uvmunmap>
    8000093c:	bff9                	j	8000091a <uvmfree+0xe>

000000008000093e <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    8000093e:	ca4d                	beqz	a2,800009f0 <uvmcopy+0xb2>
{
    80000940:	715d                	addi	sp,sp,-80
    80000942:	e486                	sd	ra,72(sp)
    80000944:	e0a2                	sd	s0,64(sp)
    80000946:	fc26                	sd	s1,56(sp)
    80000948:	f84a                	sd	s2,48(sp)
    8000094a:	f44e                	sd	s3,40(sp)
    8000094c:	f052                	sd	s4,32(sp)
    8000094e:	ec56                	sd	s5,24(sp)
    80000950:	e85a                	sd	s6,16(sp)
    80000952:	e45e                	sd	s7,8(sp)
    80000954:	e062                	sd	s8,0(sp)
    80000956:	0880                	addi	s0,sp,80
    80000958:	8baa                	mv	s7,a0
    8000095a:	8b2e                	mv	s6,a1
    8000095c:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += szinc){
    8000095e:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000960:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000962:	4601                	li	a2,0
    80000964:	85ce                	mv	a1,s3
    80000966:	855e                	mv	a0,s7
    80000968:	a7bff0ef          	jal	800003e2 <walk>
    8000096c:	cd1d                	beqz	a0,800009aa <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    8000096e:	6118                	ld	a4,0(a0)
    80000970:	00177793          	andi	a5,a4,1
    80000974:	c3a9                	beqz	a5,800009b6 <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    80000976:	00a75593          	srli	a1,a4,0xa
    8000097a:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000097e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000982:	f7cff0ef          	jal	800000fe <kalloc>
    80000986:	892a                	mv	s2,a0
    80000988:	c121                	beqz	a0,800009c8 <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    8000098a:	8652                	mv	a2,s4
    8000098c:	85e2                	mv	a1,s8
    8000098e:	825ff0ef          	jal	800001b2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000992:	8726                	mv	a4,s1
    80000994:	86ca                	mv	a3,s2
    80000996:	8652                	mv	a2,s4
    80000998:	85ce                	mv	a1,s3
    8000099a:	855a                	mv	a0,s6
    8000099c:	b29ff0ef          	jal	800004c4 <mappages>
    800009a0:	e10d                	bnez	a0,800009c2 <uvmcopy+0x84>
  for(i = 0; i < sz; i += szinc){
    800009a2:	99d2                	add	s3,s3,s4
    800009a4:	fb59efe3          	bltu	s3,s5,80000962 <uvmcopy+0x24>
    800009a8:	a805                	j	800009d8 <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    800009aa:	00006517          	auipc	a0,0x6
    800009ae:	7ae50513          	addi	a0,a0,1966 # 80007158 <etext+0x158>
    800009b2:	465040ef          	jal	80005616 <panic>
      panic("uvmcopy: page not present");
    800009b6:	00006517          	auipc	a0,0x6
    800009ba:	7c250513          	addi	a0,a0,1986 # 80007178 <etext+0x178>
    800009be:	459040ef          	jal	80005616 <panic>
      kfree(mem);
    800009c2:	854a                	mv	a0,s2
    800009c4:	e58ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009c8:	4685                	li	a3,1
    800009ca:	00c9d613          	srli	a2,s3,0xc
    800009ce:	4581                	li	a1,0
    800009d0:	855a                	mv	a0,s6
    800009d2:	c99ff0ef          	jal	8000066a <uvmunmap>
  return -1;
    800009d6:	557d                	li	a0,-1
}
    800009d8:	60a6                	ld	ra,72(sp)
    800009da:	6406                	ld	s0,64(sp)
    800009dc:	74e2                	ld	s1,56(sp)
    800009de:	7942                	ld	s2,48(sp)
    800009e0:	79a2                	ld	s3,40(sp)
    800009e2:	7a02                	ld	s4,32(sp)
    800009e4:	6ae2                	ld	s5,24(sp)
    800009e6:	6b42                	ld	s6,16(sp)
    800009e8:	6ba2                	ld	s7,8(sp)
    800009ea:	6c02                	ld	s8,0(sp)
    800009ec:	6161                	addi	sp,sp,80
    800009ee:	8082                	ret
  return 0;
    800009f0:	4501                	li	a0,0
}
    800009f2:	8082                	ret

00000000800009f4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009f4:	1141                	addi	sp,sp,-16
    800009f6:	e406                	sd	ra,8(sp)
    800009f8:	e022                	sd	s0,0(sp)
    800009fa:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009fc:	4601                	li	a2,0
    800009fe:	9e5ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    80000a02:	c901                	beqz	a0,80000a12 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a04:	611c                	ld	a5,0(a0)
    80000a06:	9bbd                	andi	a5,a5,-17
    80000a08:	e11c                	sd	a5,0(a0)
}
    80000a0a:	60a2                	ld	ra,8(sp)
    80000a0c:	6402                	ld	s0,0(sp)
    80000a0e:	0141                	addi	sp,sp,16
    80000a10:	8082                	ret
    panic("uvmclear");
    80000a12:	00006517          	auipc	a0,0x6
    80000a16:	78650513          	addi	a0,a0,1926 # 80007198 <etext+0x198>
    80000a1a:	3fd040ef          	jal	80005616 <panic>

0000000080000a1e <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a1e:	c2d1                	beqz	a3,80000aa2 <copyout+0x84>
{
    80000a20:	711d                	addi	sp,sp,-96
    80000a22:	ec86                	sd	ra,88(sp)
    80000a24:	e8a2                	sd	s0,80(sp)
    80000a26:	e4a6                	sd	s1,72(sp)
    80000a28:	e0ca                	sd	s2,64(sp)
    80000a2a:	fc4e                	sd	s3,56(sp)
    80000a2c:	f852                	sd	s4,48(sp)
    80000a2e:	f456                	sd	s5,40(sp)
    80000a30:	f05a                	sd	s6,32(sp)
    80000a32:	ec5e                	sd	s7,24(sp)
    80000a34:	e862                	sd	s8,16(sp)
    80000a36:	e466                	sd	s9,8(sp)
    80000a38:	1080                	addi	s0,sp,96
    80000a3a:	8b2a                	mv	s6,a0
    80000a3c:	89ae                	mv	s3,a1
    80000a3e:	8ab2                	mv	s5,a2
    80000a40:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a42:	7cfd                	lui	s9,0xfffff
    if (va0 >= MAXVA)
    80000a44:	5c7d                	li	s8,-1
    80000a46:	01ac5c13          	srli	s8,s8,0x1a
      return -1;
    
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000a4a:	6b85                	lui	s7,0x1
    80000a4c:	a005                	j	80000a6c <copyout+0x4e>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a4e:	412989b3          	sub	s3,s3,s2
    80000a52:	0004861b          	sext.w	a2,s1
    80000a56:	85d6                	mv	a1,s5
    80000a58:	954e                	add	a0,a0,s3
    80000a5a:	f58ff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000a5e:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a62:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a64:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80000a68:	020a0b63          	beqz	s4,80000a9e <copyout+0x80>
    va0 = PGROUNDDOWN(dstva);
    80000a6c:	0199f933          	and	s2,s3,s9
    if (va0 >= MAXVA)
    80000a70:	032c6b63          	bltu	s8,s2,80000aa6 <copyout+0x88>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a74:	4601                	li	a2,0
    80000a76:	85ca                	mv	a1,s2
    80000a78:	855a                	mv	a0,s6
    80000a7a:	969ff0ef          	jal	800003e2 <walk>
    80000a7e:	c131                	beqz	a0,80000ac2 <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a80:	611c                	ld	a5,0(a0)
    80000a82:	8b91                	andi	a5,a5,4
    80000a84:	c3a9                	beqz	a5,80000ac6 <copyout+0xa8>
    pa0 = walkaddr(pagetable, va0);
    80000a86:	85ca                	mv	a1,s2
    80000a88:	855a                	mv	a0,s6
    80000a8a:	9fdff0ef          	jal	80000486 <walkaddr>
    if(pa0 == 0)
    80000a8e:	cd15                	beqz	a0,80000aca <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000a90:	413904b3          	sub	s1,s2,s3
    80000a94:	94de                	add	s1,s1,s7
    if(n > len)
    80000a96:	fa9a7ce3          	bgeu	s4,s1,80000a4e <copyout+0x30>
    80000a9a:	84d2                	mv	s1,s4
    80000a9c:	bf4d                	j	80000a4e <copyout+0x30>
  }
  return 0;
    80000a9e:	4501                	li	a0,0
    80000aa0:	a021                	j	80000aa8 <copyout+0x8a>
    80000aa2:	4501                	li	a0,0
}
    80000aa4:	8082                	ret
      return -1;
    80000aa6:	557d                	li	a0,-1
}
    80000aa8:	60e6                	ld	ra,88(sp)
    80000aaa:	6446                	ld	s0,80(sp)
    80000aac:	64a6                	ld	s1,72(sp)
    80000aae:	6906                	ld	s2,64(sp)
    80000ab0:	79e2                	ld	s3,56(sp)
    80000ab2:	7a42                	ld	s4,48(sp)
    80000ab4:	7aa2                	ld	s5,40(sp)
    80000ab6:	7b02                	ld	s6,32(sp)
    80000ab8:	6be2                	ld	s7,24(sp)
    80000aba:	6c42                	ld	s8,16(sp)
    80000abc:	6ca2                	ld	s9,8(sp)
    80000abe:	6125                	addi	sp,sp,96
    80000ac0:	8082                	ret
      return -1;
    80000ac2:	557d                	li	a0,-1
    80000ac4:	b7d5                	j	80000aa8 <copyout+0x8a>
      return -1;
    80000ac6:	557d                	li	a0,-1
    80000ac8:	b7c5                	j	80000aa8 <copyout+0x8a>
      return -1;
    80000aca:	557d                	li	a0,-1
    80000acc:	bff1                	j	80000aa8 <copyout+0x8a>

0000000080000ace <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ace:	c6a5                	beqz	a3,80000b36 <copyin+0x68>
{
    80000ad0:	715d                	addi	sp,sp,-80
    80000ad2:	e486                	sd	ra,72(sp)
    80000ad4:	e0a2                	sd	s0,64(sp)
    80000ad6:	fc26                	sd	s1,56(sp)
    80000ad8:	f84a                	sd	s2,48(sp)
    80000ada:	f44e                	sd	s3,40(sp)
    80000adc:	f052                	sd	s4,32(sp)
    80000ade:	ec56                	sd	s5,24(sp)
    80000ae0:	e85a                	sd	s6,16(sp)
    80000ae2:	e45e                	sd	s7,8(sp)
    80000ae4:	e062                	sd	s8,0(sp)
    80000ae6:	0880                	addi	s0,sp,80
    80000ae8:	8b2a                	mv	s6,a0
    80000aea:	8a2e                	mv	s4,a1
    80000aec:	8c32                	mv	s8,a2
    80000aee:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000af0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000af2:	6a85                	lui	s5,0x1
    80000af4:	a00d                	j	80000b16 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000af6:	018505b3          	add	a1,a0,s8
    80000afa:	0004861b          	sext.w	a2,s1
    80000afe:	412585b3          	sub	a1,a1,s2
    80000b02:	8552                	mv	a0,s4
    80000b04:	eaeff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000b08:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b0c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b0e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b12:	02098063          	beqz	s3,80000b32 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b16:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b1a:	85ca                	mv	a1,s2
    80000b1c:	855a                	mv	a0,s6
    80000b1e:	969ff0ef          	jal	80000486 <walkaddr>
    if(pa0 == 0)
    80000b22:	cd01                	beqz	a0,80000b3a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b24:	418904b3          	sub	s1,s2,s8
    80000b28:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b2a:	fc99f6e3          	bgeu	s3,s1,80000af6 <copyin+0x28>
    80000b2e:	84ce                	mv	s1,s3
    80000b30:	b7d9                	j	80000af6 <copyin+0x28>
  }
  return 0;
    80000b32:	4501                	li	a0,0
    80000b34:	a021                	j	80000b3c <copyin+0x6e>
    80000b36:	4501                	li	a0,0
}
    80000b38:	8082                	ret
      return -1;
    80000b3a:	557d                	li	a0,-1
}
    80000b3c:	60a6                	ld	ra,72(sp)
    80000b3e:	6406                	ld	s0,64(sp)
    80000b40:	74e2                	ld	s1,56(sp)
    80000b42:	7942                	ld	s2,48(sp)
    80000b44:	79a2                	ld	s3,40(sp)
    80000b46:	7a02                	ld	s4,32(sp)
    80000b48:	6ae2                	ld	s5,24(sp)
    80000b4a:	6b42                	ld	s6,16(sp)
    80000b4c:	6ba2                	ld	s7,8(sp)
    80000b4e:	6c02                	ld	s8,0(sp)
    80000b50:	6161                	addi	sp,sp,80
    80000b52:	8082                	ret

0000000080000b54 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b54:	715d                	addi	sp,sp,-80
    80000b56:	e486                	sd	ra,72(sp)
    80000b58:	e0a2                	sd	s0,64(sp)
    80000b5a:	fc26                	sd	s1,56(sp)
    80000b5c:	f84a                	sd	s2,48(sp)
    80000b5e:	f44e                	sd	s3,40(sp)
    80000b60:	f052                	sd	s4,32(sp)
    80000b62:	ec56                	sd	s5,24(sp)
    80000b64:	e85a                	sd	s6,16(sp)
    80000b66:	e45e                	sd	s7,8(sp)
    80000b68:	0880                	addi	s0,sp,80
    80000b6a:	8aaa                	mv	s5,a0
    80000b6c:	89ae                	mv	s3,a1
    80000b6e:	8bb2                	mv	s7,a2
    80000b70:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b72:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b74:	6a05                	lui	s4,0x1
    80000b76:	a02d                	j	80000ba0 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b78:	00078023          	sb	zero,0(a5)
    80000b7c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b7e:	0017c793          	xori	a5,a5,1
    80000b82:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b86:	60a6                	ld	ra,72(sp)
    80000b88:	6406                	ld	s0,64(sp)
    80000b8a:	74e2                	ld	s1,56(sp)
    80000b8c:	7942                	ld	s2,48(sp)
    80000b8e:	79a2                	ld	s3,40(sp)
    80000b90:	7a02                	ld	s4,32(sp)
    80000b92:	6ae2                	ld	s5,24(sp)
    80000b94:	6b42                	ld	s6,16(sp)
    80000b96:	6ba2                	ld	s7,8(sp)
    80000b98:	6161                	addi	sp,sp,80
    80000b9a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b9c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000ba0:	c4b1                	beqz	s1,80000bec <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000ba2:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000ba6:	85ca                	mv	a1,s2
    80000ba8:	8556                	mv	a0,s5
    80000baa:	8ddff0ef          	jal	80000486 <walkaddr>
    if(pa0 == 0)
    80000bae:	c129                	beqz	a0,80000bf0 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000bb0:	41790633          	sub	a2,s2,s7
    80000bb4:	9652                	add	a2,a2,s4
    if(n > max)
    80000bb6:	00c4f363          	bgeu	s1,a2,80000bbc <copyinstr+0x68>
    80000bba:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000bbc:	412b8bb3          	sub	s7,s7,s2
    80000bc0:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000bc2:	de69                	beqz	a2,80000b9c <copyinstr+0x48>
    80000bc4:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bc6:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000bca:	964e                	add	a2,a2,s3
    80000bcc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bce:	00f68733          	add	a4,a3,a5
    80000bd2:	00074703          	lbu	a4,0(a4)
    80000bd6:	d34d                	beqz	a4,80000b78 <copyinstr+0x24>
        *dst = *p;
    80000bd8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bdc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bde:	fec797e3          	bne	a5,a2,80000bcc <copyinstr+0x78>
    80000be2:	14fd                	addi	s1,s1,-1
    80000be4:	94ce                	add	s1,s1,s3
      --max;
    80000be6:	8c8d                	sub	s1,s1,a1
    80000be8:	89be                	mv	s3,a5
    80000bea:	bf4d                	j	80000b9c <copyinstr+0x48>
    80000bec:	4781                	li	a5,0
    80000bee:	bf41                	j	80000b7e <copyinstr+0x2a>
      return -1;
    80000bf0:	557d                	li	a0,-1
    80000bf2:	bf51                	j	80000b86 <copyinstr+0x32>

0000000080000bf4 <vmprint_helper>:

// Recursive function to print the page table
void vmprint_helper(pagetable_t pagetable, int level) {
  if (!pagetable)
    80000bf4:	c14d                	beqz	a0,80000c96 <vmprint_helper+0xa2>
void vmprint_helper(pagetable_t pagetable, int level) {
    80000bf6:	711d                	addi	sp,sp,-96
    80000bf8:	ec86                	sd	ra,88(sp)
    80000bfa:	e8a2                	sd	s0,80(sp)
    80000bfc:	e4a6                	sd	s1,72(sp)
    80000bfe:	e0ca                	sd	s2,64(sp)
    80000c00:	fc4e                	sd	s3,56(sp)
    80000c02:	f852                	sd	s4,48(sp)
    80000c04:	f456                	sd	s5,40(sp)
    80000c06:	f05a                	sd	s6,32(sp)
    80000c08:	ec5e                	sd	s7,24(sp)
    80000c0a:	e862                	sd	s8,16(sp)
    80000c0c:	e466                	sd	s9,8(sp)
    80000c0e:	e06a                	sd	s10,0(sp)
    80000c10:	1080                	addi	s0,sp,96
    80000c12:	8a2a                	mv	s4,a0
    80000c14:	8aae                	mv	s5,a1
    return;

  for (int i = 0; i < 512; i++) {  // 512 entries per page table level
    80000c16:	4981                	li	s3,0
      uint64 pa = PTE2PA(pte);
      for (int j = 0; j < level; ++j) {
        printf(" ..");
      }

      printf("%d: -> pte %p pa %p\n", i, (void*)pte, (void*)pa);
    80000c18:	00006c17          	auipc	s8,0x6
    80000c1c:	598c0c13          	addi	s8,s8,1432 # 800071b0 <etext+0x1b0>

      // If the entry is a page table (not a leaf), recursively print deeper levels
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { 
          vmprint_helper((pagetable_t)pa, level + 1);
    80000c20:	00158c9b          	addiw	s9,a1,1
        printf(" ..");
    80000c24:	00006b17          	auipc	s6,0x6
    80000c28:	584b0b13          	addi	s6,s6,1412 # 800071a8 <etext+0x1a8>
  for (int i = 0; i < 512; i++) {  // 512 entries per page table level
    80000c2c:	20000b93          	li	s7,512
    80000c30:	a029                	j	80000c3a <vmprint_helper+0x46>
    80000c32:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000c34:	0a21                	addi	s4,s4,8 # 1008 <_entry-0x7fffeff8>
    80000c36:	05798263          	beq	s3,s7,80000c7a <vmprint_helper+0x86>
    pte_t pte = pagetable[i];
    80000c3a:	000a3903          	ld	s2,0(s4)
    if (pte & PTE_V) {  // Only print valid entries
    80000c3e:	00197793          	andi	a5,s2,1
    80000c42:	dbe5                	beqz	a5,80000c32 <vmprint_helper+0x3e>
      uint64 pa = PTE2PA(pte);
    80000c44:	00a95d13          	srli	s10,s2,0xa
    80000c48:	0d32                	slli	s10,s10,0xc
      for (int j = 0; j < level; ++j) {
    80000c4a:	01505963          	blez	s5,80000c5c <vmprint_helper+0x68>
    80000c4e:	4481                	li	s1,0
        printf(" ..");
    80000c50:	855a                	mv	a0,s6
    80000c52:	6f4040ef          	jal	80005346 <printf>
      for (int j = 0; j < level; ++j) {
    80000c56:	2485                	addiw	s1,s1,1
    80000c58:	fe9a9ce3          	bne	s5,s1,80000c50 <vmprint_helper+0x5c>
      printf("%d: -> pte %p pa %p\n", i, (void*)pte, (void*)pa);
    80000c5c:	86ea                	mv	a3,s10
    80000c5e:	864a                	mv	a2,s2
    80000c60:	85ce                	mv	a1,s3
    80000c62:	8562                	mv	a0,s8
    80000c64:	6e2040ef          	jal	80005346 <printf>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { 
    80000c68:	00e97913          	andi	s2,s2,14
    80000c6c:	fc0913e3          	bnez	s2,80000c32 <vmprint_helper+0x3e>
          vmprint_helper((pagetable_t)pa, level + 1);
    80000c70:	85e6                	mv	a1,s9
    80000c72:	856a                	mv	a0,s10
    80000c74:	f81ff0ef          	jal	80000bf4 <vmprint_helper>
    80000c78:	bf6d                	j	80000c32 <vmprint_helper+0x3e>
      }
    }
  }
}
    80000c7a:	60e6                	ld	ra,88(sp)
    80000c7c:	6446                	ld	s0,80(sp)
    80000c7e:	64a6                	ld	s1,72(sp)
    80000c80:	6906                	ld	s2,64(sp)
    80000c82:	79e2                	ld	s3,56(sp)
    80000c84:	7a42                	ld	s4,48(sp)
    80000c86:	7aa2                	ld	s5,40(sp)
    80000c88:	7b02                	ld	s6,32(sp)
    80000c8a:	6be2                	ld	s7,24(sp)
    80000c8c:	6c42                	ld	s8,16(sp)
    80000c8e:	6ca2                	ld	s9,8(sp)
    80000c90:	6d02                	ld	s10,0(sp)
    80000c92:	6125                	addi	sp,sp,96
    80000c94:	8082                	ret
    80000c96:	8082                	ret

0000000080000c98 <vmprint>:

// Entry function for printing the page table
void vmprint(pagetable_t pagetable) {
    80000c98:	1101                	addi	sp,sp,-32
    80000c9a:	ec06                	sd	ra,24(sp)
    80000c9c:	e822                	sd	s0,16(sp)
    80000c9e:	e426                	sd	s1,8(sp)
    80000ca0:	1000                	addi	s0,sp,32
    80000ca2:	84aa                	mv	s1,a0
    printf("page table %p\n", pagetable);
    80000ca4:	85aa                	mv	a1,a0
    80000ca6:	00006517          	auipc	a0,0x6
    80000caa:	52250513          	addi	a0,a0,1314 # 800071c8 <etext+0x1c8>
    80000cae:	698040ef          	jal	80005346 <printf>
    vmprint_helper(pagetable, 1);
    80000cb2:	4585                	li	a1,1
    80000cb4:	8526                	mv	a0,s1
    80000cb6:	f3fff0ef          	jal	80000bf4 <vmprint_helper>
}
    80000cba:	60e2                	ld	ra,24(sp)
    80000cbc:	6442                	ld	s0,16(sp)
    80000cbe:	64a2                	ld	s1,8(sp)
    80000cc0:	6105                	addi	sp,sp,32
    80000cc2:	8082                	ret

0000000080000cc4 <pgpte>:


#ifdef LAB_PGTBL
pte_t*
pgpte(pagetable_t pagetable, uint64 va) {
    80000cc4:	1141                	addi	sp,sp,-16
    80000cc6:	e406                	sd	ra,8(sp)
    80000cc8:	e022                	sd	s0,0(sp)
    80000cca:	0800                	addi	s0,sp,16
  return walk(pagetable, va, 0);
    80000ccc:	4601                	li	a2,0
    80000cce:	f14ff0ef          	jal	800003e2 <walk>
}
    80000cd2:	60a2                	ld	ra,8(sp)
    80000cd4:	6402                	ld	s0,0(sp)
    80000cd6:	0141                	addi	sp,sp,16
    80000cd8:	8082                	ret

0000000080000cda <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cda:	715d                	addi	sp,sp,-80
    80000cdc:	e486                	sd	ra,72(sp)
    80000cde:	e0a2                	sd	s0,64(sp)
    80000ce0:	fc26                	sd	s1,56(sp)
    80000ce2:	f84a                	sd	s2,48(sp)
    80000ce4:	f44e                	sd	s3,40(sp)
    80000ce6:	f052                	sd	s4,32(sp)
    80000ce8:	ec56                	sd	s5,24(sp)
    80000cea:	e85a                	sd	s6,16(sp)
    80000cec:	e45e                	sd	s7,8(sp)
    80000cee:	e062                	sd	s8,0(sp)
    80000cf0:	0880                	addi	s0,sp,80
    80000cf2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	0000a497          	auipc	s1,0xa
    80000cf8:	c0c48493          	addi	s1,s1,-1012 # 8000a900 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfc:	8c26                	mv	s8,s1
    80000cfe:	a4fa57b7          	lui	a5,0xa4fa5
    80000d02:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f817c5>
    80000d06:	4fa50937          	lui	s2,0x4fa50
    80000d0a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000d0e:	1902                	slli	s2,s2,0x20
    80000d10:	993e                	add	s2,s2,a5
    80000d12:	010009b7          	lui	s3,0x1000
    80000d16:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d18:	09ba                	slli	s3,s3,0xe
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1a:	4b99                	li	s7,6
    80000d1c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1e:	0000fa97          	auipc	s5,0xf
    80000d22:	5e2a8a93          	addi	s5,s5,1506 # 80010300 <tickslock>
    char *pa = kalloc();
    80000d26:	bd8ff0ef          	jal	800000fe <kalloc>
    80000d2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d2c:	cd1d                	beqz	a0,80000d6a <proc_mapstacks+0x90>
    uint64 va = KSTACK((int) (p - proc));
    80000d2e:	418485b3          	sub	a1,s1,s8
    80000d32:	858d                	srai	a1,a1,0x3
    80000d34:	032585b3          	mul	a1,a1,s2
    80000d38:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d3c:	875e                	mv	a4,s7
    80000d3e:	86da                	mv	a3,s6
    80000d40:	40b985b3          	sub	a1,s3,a1
    80000d44:	8552                	mv	a0,s4
    80000d46:	835ff0ef          	jal	8000057a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	16848493          	addi	s1,s1,360
    80000d4e:	fd549ce3          	bne	s1,s5,80000d26 <proc_mapstacks+0x4c>
  }
}
    80000d52:	60a6                	ld	ra,72(sp)
    80000d54:	6406                	ld	s0,64(sp)
    80000d56:	74e2                	ld	s1,56(sp)
    80000d58:	7942                	ld	s2,48(sp)
    80000d5a:	79a2                	ld	s3,40(sp)
    80000d5c:	7a02                	ld	s4,32(sp)
    80000d5e:	6ae2                	ld	s5,24(sp)
    80000d60:	6b42                	ld	s6,16(sp)
    80000d62:	6ba2                	ld	s7,8(sp)
    80000d64:	6c02                	ld	s8,0(sp)
    80000d66:	6161                	addi	sp,sp,80
    80000d68:	8082                	ret
      panic("kalloc");
    80000d6a:	00006517          	auipc	a0,0x6
    80000d6e:	46e50513          	addi	a0,a0,1134 # 800071d8 <etext+0x1d8>
    80000d72:	0a5040ef          	jal	80005616 <panic>

0000000080000d76 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d76:	7139                	addi	sp,sp,-64
    80000d78:	fc06                	sd	ra,56(sp)
    80000d7a:	f822                	sd	s0,48(sp)
    80000d7c:	f426                	sd	s1,40(sp)
    80000d7e:	f04a                	sd	s2,32(sp)
    80000d80:	ec4e                	sd	s3,24(sp)
    80000d82:	e852                	sd	s4,16(sp)
    80000d84:	e456                	sd	s5,8(sp)
    80000d86:	e05a                	sd	s6,0(sp)
    80000d88:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8a:	00006597          	auipc	a1,0x6
    80000d8e:	45658593          	addi	a1,a1,1110 # 800071e0 <etext+0x1e0>
    80000d92:	00009517          	auipc	a0,0x9
    80000d96:	73e50513          	addi	a0,a0,1854 # 8000a4d0 <pid_lock>
    80000d9a:	327040ef          	jal	800058c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00006597          	auipc	a1,0x6
    80000da2:	44a58593          	addi	a1,a1,1098 # 800071e8 <etext+0x1e8>
    80000da6:	00009517          	auipc	a0,0x9
    80000daa:	74250513          	addi	a0,a0,1858 # 8000a4e8 <wait_lock>
    80000dae:	313040ef          	jal	800058c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db2:	0000a497          	auipc	s1,0xa
    80000db6:	b4e48493          	addi	s1,s1,-1202 # 8000a900 <proc>
      initlock(&p->lock, "proc");
    80000dba:	00006a97          	auipc	s5,0x6
    80000dbe:	43ea8a93          	addi	s5,s5,1086 # 800071f8 <etext+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc2:	8a26                	mv	s4,s1
    80000dc4:	a4fa57b7          	lui	a5,0xa4fa5
    80000dc8:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f817c5>
    80000dcc:	4fa50937          	lui	s2,0x4fa50
    80000dd0:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000dd4:	1902                	slli	s2,s2,0x20
    80000dd6:	993e                	add	s2,s2,a5
    80000dd8:	010009b7          	lui	s3,0x1000
    80000ddc:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000dde:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de0:	0000fb17          	auipc	s6,0xf
    80000de4:	520b0b13          	addi	s6,s6,1312 # 80010300 <tickslock>
      initlock(&p->lock, "proc");
    80000de8:	85d6                	mv	a1,s5
    80000dea:	8526                	mv	a0,s1
    80000dec:	2d5040ef          	jal	800058c0 <initlock>
      p->state = UNUSED;
    80000df0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df4:	414487b3          	sub	a5,s1,s4
    80000df8:	878d                	srai	a5,a5,0x3
    80000dfa:	032787b3          	mul	a5,a5,s2
    80000dfe:	00d7979b          	slliw	a5,a5,0xd
    80000e02:	40f987b3          	sub	a5,s3,a5
    80000e06:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e08:	16848493          	addi	s1,s1,360
    80000e0c:	fd649ee3          	bne	s1,s6,80000de8 <procinit+0x72>
  }
}
    80000e10:	70e2                	ld	ra,56(sp)
    80000e12:	7442                	ld	s0,48(sp)
    80000e14:	74a2                	ld	s1,40(sp)
    80000e16:	7902                	ld	s2,32(sp)
    80000e18:	69e2                	ld	s3,24(sp)
    80000e1a:	6a42                	ld	s4,16(sp)
    80000e1c:	6aa2                	ld	s5,8(sp)
    80000e1e:	6b02                	ld	s6,0(sp)
    80000e20:	6121                	addi	sp,sp,64
    80000e22:	8082                	ret

0000000080000e24 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e406                	sd	ra,8(sp)
    80000e28:	e022                	sd	s0,0(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	60a2                	ld	ra,8(sp)
    80000e32:	6402                	ld	s0,0(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e406                	sd	ra,8(sp)
    80000e3c:	e022                	sd	s0,0(sp)
    80000e3e:	0800                	addi	s0,sp,16
    80000e40:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e42:	2781                	sext.w	a5,a5
    80000e44:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e46:	00009517          	auipc	a0,0x9
    80000e4a:	6ba50513          	addi	a0,a0,1722 # 8000a500 <cpus>
    80000e4e:	953e                	add	a0,a0,a5
    80000e50:	60a2                	ld	ra,8(sp)
    80000e52:	6402                	ld	s0,0(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e58:	1101                	addi	sp,sp,-32
    80000e5a:	ec06                	sd	ra,24(sp)
    80000e5c:	e822                	sd	s0,16(sp)
    80000e5e:	e426                	sd	s1,8(sp)
    80000e60:	1000                	addi	s0,sp,32
  push_off();
    80000e62:	2a3040ef          	jal	80005904 <push_off>
    80000e66:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00009717          	auipc	a4,0x9
    80000e70:	66470713          	addi	a4,a4,1636 # 8000a4d0 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e78:	311040ef          	jal	80005988 <pop_off>
  return p;
}
    80000e7c:	8526                	mv	a0,s1
    80000e7e:	60e2                	ld	ra,24(sp)
    80000e80:	6442                	ld	s0,16(sp)
    80000e82:	64a2                	ld	s1,8(sp)
    80000e84:	6105                	addi	sp,sp,32
    80000e86:	8082                	ret

0000000080000e88 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e88:	1141                	addi	sp,sp,-16
    80000e8a:	e406                	sd	ra,8(sp)
    80000e8c:	e022                	sd	s0,0(sp)
    80000e8e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e90:	fc9ff0ef          	jal	80000e58 <myproc>
    80000e94:	345040ef          	jal	800059d8 <release>

  if (first) {
    80000e98:	00009797          	auipc	a5,0x9
    80000e9c:	5787a783          	lw	a5,1400(a5) # 8000a410 <first.1>
    80000ea0:	e799                	bnez	a5,80000eae <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000ea2:	2bd000ef          	jal	8000195e <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    fsinit(ROOTDEV);
    80000eae:	4505                	li	a0,1
    80000eb0:	740010ef          	jal	800025f0 <fsinit>
    first = 0;
    80000eb4:	00009797          	auipc	a5,0x9
    80000eb8:	5407ae23          	sw	zero,1372(a5) # 8000a410 <first.1>
    __sync_synchronize();
    80000ebc:	0330000f          	fence	rw,rw
    80000ec0:	b7cd                	j	80000ea2 <forkret+0x1a>

0000000080000ec2 <allocpid>:
{
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00009917          	auipc	s2,0x9
    80000ed2:	60290913          	addi	s2,s2,1538 # 8000a4d0 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	26d040ef          	jal	80005944 <acquire>
  pid = nextpid;
    80000edc:	00009797          	auipc	a5,0x9
    80000ee0:	53878793          	addi	a5,a5,1336 # 8000a414 <nextpid>
    80000ee4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee6:	0014871b          	addiw	a4,s1,1
    80000eea:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eec:	854a                	mv	a0,s2
    80000eee:	2eb040ef          	jal	800059d8 <release>
}
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	60e2                	ld	ra,24(sp)
    80000ef6:	6442                	ld	s0,16(sp)
    80000ef8:	64a2                	ld	s1,8(sp)
    80000efa:	6902                	ld	s2,0(sp)
    80000efc:	6105                	addi	sp,sp,32
    80000efe:	8082                	ret

0000000080000f00 <proc_pagetable>:
{
    80000f00:	1101                	addi	sp,sp,-32
    80000f02:	ec06                	sd	ra,24(sp)
    80000f04:	e822                	sd	s0,16(sp)
    80000f06:	e426                	sd	s1,8(sp)
    80000f08:	e04a                	sd	s2,0(sp)
    80000f0a:	1000                	addi	s0,sp,32
    80000f0c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f0e:	829ff0ef          	jal	80000736 <uvmcreate>
    80000f12:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f14:	cd05                	beqz	a0,80000f4c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f16:	4729                	li	a4,10
    80000f18:	00005697          	auipc	a3,0x5
    80000f1c:	0e868693          	addi	a3,a3,232 # 80006000 <_trampoline>
    80000f20:	6605                	lui	a2,0x1
    80000f22:	040005b7          	lui	a1,0x4000
    80000f26:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f28:	05b2                	slli	a1,a1,0xc
    80000f2a:	d9aff0ef          	jal	800004c4 <mappages>
    80000f2e:	02054663          	bltz	a0,80000f5a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f32:	4719                	li	a4,6
    80000f34:	05893683          	ld	a3,88(s2)
    80000f38:	6605                	lui	a2,0x1
    80000f3a:	020005b7          	lui	a1,0x2000
    80000f3e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f40:	05b6                	slli	a1,a1,0xd
    80000f42:	8526                	mv	a0,s1
    80000f44:	d80ff0ef          	jal	800004c4 <mappages>
    80000f48:	00054f63          	bltz	a0,80000f66 <proc_pagetable+0x66>
}
    80000f4c:	8526                	mv	a0,s1
    80000f4e:	60e2                	ld	ra,24(sp)
    80000f50:	6442                	ld	s0,16(sp)
    80000f52:	64a2                	ld	s1,8(sp)
    80000f54:	6902                	ld	s2,0(sp)
    80000f56:	6105                	addi	sp,sp,32
    80000f58:	8082                	ret
    uvmfree(pagetable, 0);
    80000f5a:	4581                	li	a1,0
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	9afff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000f62:	4481                	li	s1,0
    80000f64:	b7e5                	j	80000f4c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f66:	4681                	li	a3,0
    80000f68:	4605                	li	a2,1
    80000f6a:	040005b7          	lui	a1,0x4000
    80000f6e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f70:	05b2                	slli	a1,a1,0xc
    80000f72:	8526                	mv	a0,s1
    80000f74:	ef6ff0ef          	jal	8000066a <uvmunmap>
    uvmfree(pagetable, 0);
    80000f78:	4581                	li	a1,0
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	991ff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000f80:	4481                	li	s1,0
    80000f82:	b7e9                	j	80000f4c <proc_pagetable+0x4c>

0000000080000f84 <proc_freepagetable>:
{
    80000f84:	1101                	addi	sp,sp,-32
    80000f86:	ec06                	sd	ra,24(sp)
    80000f88:	e822                	sd	s0,16(sp)
    80000f8a:	e426                	sd	s1,8(sp)
    80000f8c:	e04a                	sd	s2,0(sp)
    80000f8e:	1000                	addi	s0,sp,32
    80000f90:	84aa                	mv	s1,a0
    80000f92:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f94:	4681                	li	a3,0
    80000f96:	4605                	li	a2,1
    80000f98:	040005b7          	lui	a1,0x4000
    80000f9c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f9e:	05b2                	slli	a1,a1,0xc
    80000fa0:	ecaff0ef          	jal	8000066a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fa4:	4681                	li	a3,0
    80000fa6:	4605                	li	a2,1
    80000fa8:	020005b7          	lui	a1,0x2000
    80000fac:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fae:	05b6                	slli	a1,a1,0xd
    80000fb0:	8526                	mv	a0,s1
    80000fb2:	eb8ff0ef          	jal	8000066a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fb6:	85ca                	mv	a1,s2
    80000fb8:	8526                	mv	a0,s1
    80000fba:	953ff0ef          	jal	8000090c <uvmfree>
}
    80000fbe:	60e2                	ld	ra,24(sp)
    80000fc0:	6442                	ld	s0,16(sp)
    80000fc2:	64a2                	ld	s1,8(sp)
    80000fc4:	6902                	ld	s2,0(sp)
    80000fc6:	6105                	addi	sp,sp,32
    80000fc8:	8082                	ret

0000000080000fca <freeproc>:
{
    80000fca:	1101                	addi	sp,sp,-32
    80000fcc:	ec06                	sd	ra,24(sp)
    80000fce:	e822                	sd	s0,16(sp)
    80000fd0:	e426                	sd	s1,8(sp)
    80000fd2:	1000                	addi	s0,sp,32
    80000fd4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fd6:	6d28                	ld	a0,88(a0)
    80000fd8:	c119                	beqz	a0,80000fde <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000fda:	842ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000fde:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000fe2:	68a8                	ld	a0,80(s1)
    80000fe4:	c501                	beqz	a0,80000fec <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000fe6:	64ac                	ld	a1,72(s1)
    80000fe8:	f9dff0ef          	jal	80000f84 <proc_freepagetable>
  p->pagetable = 0;
    80000fec:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ff0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ff4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000ff8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000ffc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001000:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001004:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001008:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000100c:	0004ac23          	sw	zero,24(s1)
}
    80001010:	60e2                	ld	ra,24(sp)
    80001012:	6442                	ld	s0,16(sp)
    80001014:	64a2                	ld	s1,8(sp)
    80001016:	6105                	addi	sp,sp,32
    80001018:	8082                	ret

000000008000101a <allocproc>:
{
    8000101a:	1101                	addi	sp,sp,-32
    8000101c:	ec06                	sd	ra,24(sp)
    8000101e:	e822                	sd	s0,16(sp)
    80001020:	e426                	sd	s1,8(sp)
    80001022:	e04a                	sd	s2,0(sp)
    80001024:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001026:	0000a497          	auipc	s1,0xa
    8000102a:	8da48493          	addi	s1,s1,-1830 # 8000a900 <proc>
    8000102e:	0000f917          	auipc	s2,0xf
    80001032:	2d290913          	addi	s2,s2,722 # 80010300 <tickslock>
    acquire(&p->lock);
    80001036:	8526                	mv	a0,s1
    80001038:	10d040ef          	jal	80005944 <acquire>
    if(p->state == UNUSED) {
    8000103c:	4c9c                	lw	a5,24(s1)
    8000103e:	cb91                	beqz	a5,80001052 <allocproc+0x38>
      release(&p->lock);
    80001040:	8526                	mv	a0,s1
    80001042:	197040ef          	jal	800059d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001046:	16848493          	addi	s1,s1,360
    8000104a:	ff2496e3          	bne	s1,s2,80001036 <allocproc+0x1c>
  return 0;
    8000104e:	4481                	li	s1,0
    80001050:	a089                	j	80001092 <allocproc+0x78>
  p->pid = allocpid();
    80001052:	e71ff0ef          	jal	80000ec2 <allocpid>
    80001056:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001058:	4785                	li	a5,1
    8000105a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000105c:	8a2ff0ef          	jal	800000fe <kalloc>
    80001060:	892a                	mv	s2,a0
    80001062:	eca8                	sd	a0,88(s1)
    80001064:	cd15                	beqz	a0,800010a0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001066:	8526                	mv	a0,s1
    80001068:	e99ff0ef          	jal	80000f00 <proc_pagetable>
    8000106c:	892a                	mv	s2,a0
    8000106e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001070:	c121                	beqz	a0,800010b0 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001072:	07000613          	li	a2,112
    80001076:	4581                	li	a1,0
    80001078:	06048513          	addi	a0,s1,96
    8000107c:	8d2ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001080:	00000797          	auipc	a5,0x0
    80001084:	e0878793          	addi	a5,a5,-504 # 80000e88 <forkret>
    80001088:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000108a:	60bc                	ld	a5,64(s1)
    8000108c:	6705                	lui	a4,0x1
    8000108e:	97ba                	add	a5,a5,a4
    80001090:	f4bc                	sd	a5,104(s1)
}
    80001092:	8526                	mv	a0,s1
    80001094:	60e2                	ld	ra,24(sp)
    80001096:	6442                	ld	s0,16(sp)
    80001098:	64a2                	ld	s1,8(sp)
    8000109a:	6902                	ld	s2,0(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret
    freeproc(p);
    800010a0:	8526                	mv	a0,s1
    800010a2:	f29ff0ef          	jal	80000fca <freeproc>
    release(&p->lock);
    800010a6:	8526                	mv	a0,s1
    800010a8:	131040ef          	jal	800059d8 <release>
    return 0;
    800010ac:	84ca                	mv	s1,s2
    800010ae:	b7d5                	j	80001092 <allocproc+0x78>
    freeproc(p);
    800010b0:	8526                	mv	a0,s1
    800010b2:	f19ff0ef          	jal	80000fca <freeproc>
    release(&p->lock);
    800010b6:	8526                	mv	a0,s1
    800010b8:	121040ef          	jal	800059d8 <release>
    return 0;
    800010bc:	84ca                	mv	s1,s2
    800010be:	bfd1                	j	80001092 <allocproc+0x78>

00000000800010c0 <userinit>:
{
    800010c0:	1101                	addi	sp,sp,-32
    800010c2:	ec06                	sd	ra,24(sp)
    800010c4:	e822                	sd	s0,16(sp)
    800010c6:	e426                	sd	s1,8(sp)
    800010c8:	1000                	addi	s0,sp,32
  p = allocproc();
    800010ca:	f51ff0ef          	jal	8000101a <allocproc>
    800010ce:	84aa                	mv	s1,a0
  initproc = p;
    800010d0:	00009797          	auipc	a5,0x9
    800010d4:	3ca7b023          	sd	a0,960(a5) # 8000a490 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800010d8:	03400613          	li	a2,52
    800010dc:	00009597          	auipc	a1,0x9
    800010e0:	34458593          	addi	a1,a1,836 # 8000a420 <initcode>
    800010e4:	6928                	ld	a0,80(a0)
    800010e6:	e76ff0ef          	jal	8000075c <uvmfirst>
  p->sz = PGSIZE;
    800010ea:	6785                	lui	a5,0x1
    800010ec:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800010ee:	6cb8                	ld	a4,88(s1)
    800010f0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800010f4:	6cb8                	ld	a4,88(s1)
    800010f6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800010f8:	4641                	li	a2,16
    800010fa:	00006597          	auipc	a1,0x6
    800010fe:	10658593          	addi	a1,a1,262 # 80007200 <etext+0x200>
    80001102:	15848513          	addi	a0,s1,344
    80001106:	99aff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    8000110a:	00006517          	auipc	a0,0x6
    8000110e:	10650513          	addi	a0,a0,262 # 80007210 <etext+0x210>
    80001112:	603010ef          	jal	80002f14 <namei>
    80001116:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000111a:	478d                	li	a5,3
    8000111c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	0b9040ef          	jal	800059d8 <release>
}
    80001124:	60e2                	ld	ra,24(sp)
    80001126:	6442                	ld	s0,16(sp)
    80001128:	64a2                	ld	s1,8(sp)
    8000112a:	6105                	addi	sp,sp,32
    8000112c:	8082                	ret

000000008000112e <growproc>:
{
    8000112e:	1101                	addi	sp,sp,-32
    80001130:	ec06                	sd	ra,24(sp)
    80001132:	e822                	sd	s0,16(sp)
    80001134:	e426                	sd	s1,8(sp)
    80001136:	e04a                	sd	s2,0(sp)
    80001138:	1000                	addi	s0,sp,32
    8000113a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000113c:	d1dff0ef          	jal	80000e58 <myproc>
    80001140:	84aa                	mv	s1,a0
  sz = p->sz;
    80001142:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001144:	01204c63          	bgtz	s2,8000115c <growproc+0x2e>
  } else if(n < 0){
    80001148:	02094463          	bltz	s2,80001170 <growproc+0x42>
  p->sz = sz;
    8000114c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000114e:	4501                	li	a0,0
}
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6902                	ld	s2,0(sp)
    80001158:	6105                	addi	sp,sp,32
    8000115a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000115c:	4691                	li	a3,4
    8000115e:	00b90633          	add	a2,s2,a1
    80001162:	6928                	ld	a0,80(a0)
    80001164:	e9aff0ef          	jal	800007fe <uvmalloc>
    80001168:	85aa                	mv	a1,a0
    8000116a:	f16d                	bnez	a0,8000114c <growproc+0x1e>
      return -1;
    8000116c:	557d                	li	a0,-1
    8000116e:	b7cd                	j	80001150 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001170:	00b90633          	add	a2,s2,a1
    80001174:	6928                	ld	a0,80(a0)
    80001176:	e44ff0ef          	jal	800007ba <uvmdealloc>
    8000117a:	85aa                	mv	a1,a0
    8000117c:	bfc1                	j	8000114c <growproc+0x1e>

000000008000117e <fork>:
{
    8000117e:	7139                	addi	sp,sp,-64
    80001180:	fc06                	sd	ra,56(sp)
    80001182:	f822                	sd	s0,48(sp)
    80001184:	f04a                	sd	s2,32(sp)
    80001186:	e456                	sd	s5,8(sp)
    80001188:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000118a:	ccfff0ef          	jal	80000e58 <myproc>
    8000118e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001190:	e8bff0ef          	jal	8000101a <allocproc>
    80001194:	0e050a63          	beqz	a0,80001288 <fork+0x10a>
    80001198:	e852                	sd	s4,16(sp)
    8000119a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000119c:	048ab603          	ld	a2,72(s5)
    800011a0:	692c                	ld	a1,80(a0)
    800011a2:	050ab503          	ld	a0,80(s5)
    800011a6:	f98ff0ef          	jal	8000093e <uvmcopy>
    800011aa:	04054a63          	bltz	a0,800011fe <fork+0x80>
    800011ae:	f426                	sd	s1,40(sp)
    800011b0:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800011b2:	048ab783          	ld	a5,72(s5)
    800011b6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800011ba:	058ab683          	ld	a3,88(s5)
    800011be:	87b6                	mv	a5,a3
    800011c0:	058a3703          	ld	a4,88(s4)
    800011c4:	12068693          	addi	a3,a3,288
    800011c8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800011cc:	6788                	ld	a0,8(a5)
    800011ce:	6b8c                	ld	a1,16(a5)
    800011d0:	6f90                	ld	a2,24(a5)
    800011d2:	01073023          	sd	a6,0(a4)
    800011d6:	e708                	sd	a0,8(a4)
    800011d8:	eb0c                	sd	a1,16(a4)
    800011da:	ef10                	sd	a2,24(a4)
    800011dc:	02078793          	addi	a5,a5,32
    800011e0:	02070713          	addi	a4,a4,32
    800011e4:	fed792e3          	bne	a5,a3,800011c8 <fork+0x4a>
  np->trapframe->a0 = 0;
    800011e8:	058a3783          	ld	a5,88(s4)
    800011ec:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800011f0:	0d0a8493          	addi	s1,s5,208
    800011f4:	0d0a0913          	addi	s2,s4,208
    800011f8:	150a8993          	addi	s3,s5,336
    800011fc:	a831                	j	80001218 <fork+0x9a>
    freeproc(np);
    800011fe:	8552                	mv	a0,s4
    80001200:	dcbff0ef          	jal	80000fca <freeproc>
    release(&np->lock);
    80001204:	8552                	mv	a0,s4
    80001206:	7d2040ef          	jal	800059d8 <release>
    return -1;
    8000120a:	597d                	li	s2,-1
    8000120c:	6a42                	ld	s4,16(sp)
    8000120e:	a0b5                	j	8000127a <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001210:	04a1                	addi	s1,s1,8
    80001212:	0921                	addi	s2,s2,8
    80001214:	01348963          	beq	s1,s3,80001226 <fork+0xa8>
    if(p->ofile[i])
    80001218:	6088                	ld	a0,0(s1)
    8000121a:	d97d                	beqz	a0,80001210 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000121c:	294020ef          	jal	800034b0 <filedup>
    80001220:	00a93023          	sd	a0,0(s2)
    80001224:	b7f5                	j	80001210 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001226:	150ab503          	ld	a0,336(s5)
    8000122a:	5c4010ef          	jal	800027ee <idup>
    8000122e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001232:	4641                	li	a2,16
    80001234:	158a8593          	addi	a1,s5,344
    80001238:	158a0513          	addi	a0,s4,344
    8000123c:	864ff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001240:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001244:	8552                	mv	a0,s4
    80001246:	792040ef          	jal	800059d8 <release>
  acquire(&wait_lock);
    8000124a:	00009497          	auipc	s1,0x9
    8000124e:	29e48493          	addi	s1,s1,670 # 8000a4e8 <wait_lock>
    80001252:	8526                	mv	a0,s1
    80001254:	6f0040ef          	jal	80005944 <acquire>
  np->parent = p;
    80001258:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000125c:	8526                	mv	a0,s1
    8000125e:	77a040ef          	jal	800059d8 <release>
  acquire(&np->lock);
    80001262:	8552                	mv	a0,s4
    80001264:	6e0040ef          	jal	80005944 <acquire>
  np->state = RUNNABLE;
    80001268:	478d                	li	a5,3
    8000126a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000126e:	8552                	mv	a0,s4
    80001270:	768040ef          	jal	800059d8 <release>
  return pid;
    80001274:	74a2                	ld	s1,40(sp)
    80001276:	69e2                	ld	s3,24(sp)
    80001278:	6a42                	ld	s4,16(sp)
}
    8000127a:	854a                	mv	a0,s2
    8000127c:	70e2                	ld	ra,56(sp)
    8000127e:	7442                	ld	s0,48(sp)
    80001280:	7902                	ld	s2,32(sp)
    80001282:	6aa2                	ld	s5,8(sp)
    80001284:	6121                	addi	sp,sp,64
    80001286:	8082                	ret
    return -1;
    80001288:	597d                	li	s2,-1
    8000128a:	bfc5                	j	8000127a <fork+0xfc>

000000008000128c <scheduler>:
{
    8000128c:	715d                	addi	sp,sp,-80
    8000128e:	e486                	sd	ra,72(sp)
    80001290:	e0a2                	sd	s0,64(sp)
    80001292:	fc26                	sd	s1,56(sp)
    80001294:	f84a                	sd	s2,48(sp)
    80001296:	f44e                	sd	s3,40(sp)
    80001298:	f052                	sd	s4,32(sp)
    8000129a:	ec56                	sd	s5,24(sp)
    8000129c:	e85a                	sd	s6,16(sp)
    8000129e:	e45e                	sd	s7,8(sp)
    800012a0:	e062                	sd	s8,0(sp)
    800012a2:	0880                	addi	s0,sp,80
    800012a4:	8792                	mv	a5,tp
  int id = r_tp();
    800012a6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800012a8:	00779b13          	slli	s6,a5,0x7
    800012ac:	00009717          	auipc	a4,0x9
    800012b0:	22470713          	addi	a4,a4,548 # 8000a4d0 <pid_lock>
    800012b4:	975a                	add	a4,a4,s6
    800012b6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012ba:	00009717          	auipc	a4,0x9
    800012be:	24e70713          	addi	a4,a4,590 # 8000a508 <cpus+0x8>
    800012c2:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800012c4:	4c11                	li	s8,4
        c->proc = p;
    800012c6:	079e                	slli	a5,a5,0x7
    800012c8:	00009a17          	auipc	s4,0x9
    800012cc:	208a0a13          	addi	s4,s4,520 # 8000a4d0 <pid_lock>
    800012d0:	9a3e                	add	s4,s4,a5
        found = 1;
    800012d2:	4b85                	li	s7,1
    800012d4:	a0a9                	j	8000131e <scheduler+0x92>
      release(&p->lock);
    800012d6:	8526                	mv	a0,s1
    800012d8:	700040ef          	jal	800059d8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012dc:	16848493          	addi	s1,s1,360
    800012e0:	03248563          	beq	s1,s2,8000130a <scheduler+0x7e>
      acquire(&p->lock);
    800012e4:	8526                	mv	a0,s1
    800012e6:	65e040ef          	jal	80005944 <acquire>
      if(p->state == RUNNABLE) {
    800012ea:	4c9c                	lw	a5,24(s1)
    800012ec:	ff3795e3          	bne	a5,s3,800012d6 <scheduler+0x4a>
        p->state = RUNNING;
    800012f0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012f4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800012f8:	06048593          	addi	a1,s1,96
    800012fc:	855a                	mv	a0,s6
    800012fe:	5b6000ef          	jal	800018b4 <swtch>
        c->proc = 0;
    80001302:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001306:	8ade                	mv	s5,s7
    80001308:	b7f9                	j	800012d6 <scheduler+0x4a>
    if(found == 0) {
    8000130a:	000a9a63          	bnez	s5,8000131e <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000130e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001312:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001316:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000131a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000131e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001322:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001326:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000132a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000132c:	00009497          	auipc	s1,0x9
    80001330:	5d448493          	addi	s1,s1,1492 # 8000a900 <proc>
      if(p->state == RUNNABLE) {
    80001334:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001336:	0000f917          	auipc	s2,0xf
    8000133a:	fca90913          	addi	s2,s2,-54 # 80010300 <tickslock>
    8000133e:	b75d                	j	800012e4 <scheduler+0x58>

0000000080001340 <sched>:
{
    80001340:	7179                	addi	sp,sp,-48
    80001342:	f406                	sd	ra,40(sp)
    80001344:	f022                	sd	s0,32(sp)
    80001346:	ec26                	sd	s1,24(sp)
    80001348:	e84a                	sd	s2,16(sp)
    8000134a:	e44e                	sd	s3,8(sp)
    8000134c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000134e:	b0bff0ef          	jal	80000e58 <myproc>
    80001352:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001354:	586040ef          	jal	800058da <holding>
    80001358:	c92d                	beqz	a0,800013ca <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000135a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000135c:	2781                	sext.w	a5,a5
    8000135e:	079e                	slli	a5,a5,0x7
    80001360:	00009717          	auipc	a4,0x9
    80001364:	17070713          	addi	a4,a4,368 # 8000a4d0 <pid_lock>
    80001368:	97ba                	add	a5,a5,a4
    8000136a:	0a87a703          	lw	a4,168(a5)
    8000136e:	4785                	li	a5,1
    80001370:	06f71363          	bne	a4,a5,800013d6 <sched+0x96>
  if(p->state == RUNNING)
    80001374:	4c98                	lw	a4,24(s1)
    80001376:	4791                	li	a5,4
    80001378:	06f70563          	beq	a4,a5,800013e2 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001380:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001382:	e7b5                	bnez	a5,800013ee <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001384:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001386:	00009917          	auipc	s2,0x9
    8000138a:	14a90913          	addi	s2,s2,330 # 8000a4d0 <pid_lock>
    8000138e:	2781                	sext.w	a5,a5
    80001390:	079e                	slli	a5,a5,0x7
    80001392:	97ca                	add	a5,a5,s2
    80001394:	0ac7a983          	lw	s3,172(a5)
    80001398:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000139a:	2781                	sext.w	a5,a5
    8000139c:	079e                	slli	a5,a5,0x7
    8000139e:	00009597          	auipc	a1,0x9
    800013a2:	16a58593          	addi	a1,a1,362 # 8000a508 <cpus+0x8>
    800013a6:	95be                	add	a1,a1,a5
    800013a8:	06048513          	addi	a0,s1,96
    800013ac:	508000ef          	jal	800018b4 <swtch>
    800013b0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013b2:	2781                	sext.w	a5,a5
    800013b4:	079e                	slli	a5,a5,0x7
    800013b6:	993e                	add	s2,s2,a5
    800013b8:	0b392623          	sw	s3,172(s2)
}
    800013bc:	70a2                	ld	ra,40(sp)
    800013be:	7402                	ld	s0,32(sp)
    800013c0:	64e2                	ld	s1,24(sp)
    800013c2:	6942                	ld	s2,16(sp)
    800013c4:	69a2                	ld	s3,8(sp)
    800013c6:	6145                	addi	sp,sp,48
    800013c8:	8082                	ret
    panic("sched p->lock");
    800013ca:	00006517          	auipc	a0,0x6
    800013ce:	e4e50513          	addi	a0,a0,-434 # 80007218 <etext+0x218>
    800013d2:	244040ef          	jal	80005616 <panic>
    panic("sched locks");
    800013d6:	00006517          	auipc	a0,0x6
    800013da:	e5250513          	addi	a0,a0,-430 # 80007228 <etext+0x228>
    800013de:	238040ef          	jal	80005616 <panic>
    panic("sched running");
    800013e2:	00006517          	auipc	a0,0x6
    800013e6:	e5650513          	addi	a0,a0,-426 # 80007238 <etext+0x238>
    800013ea:	22c040ef          	jal	80005616 <panic>
    panic("sched interruptible");
    800013ee:	00006517          	auipc	a0,0x6
    800013f2:	e5a50513          	addi	a0,a0,-422 # 80007248 <etext+0x248>
    800013f6:	220040ef          	jal	80005616 <panic>

00000000800013fa <yield>:
{
    800013fa:	1101                	addi	sp,sp,-32
    800013fc:	ec06                	sd	ra,24(sp)
    800013fe:	e822                	sd	s0,16(sp)
    80001400:	e426                	sd	s1,8(sp)
    80001402:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001404:	a55ff0ef          	jal	80000e58 <myproc>
    80001408:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000140a:	53a040ef          	jal	80005944 <acquire>
  p->state = RUNNABLE;
    8000140e:	478d                	li	a5,3
    80001410:	cc9c                	sw	a5,24(s1)
  sched();
    80001412:	f2fff0ef          	jal	80001340 <sched>
  release(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	5c0040ef          	jal	800059d8 <release>
}
    8000141c:	60e2                	ld	ra,24(sp)
    8000141e:	6442                	ld	s0,16(sp)
    80001420:	64a2                	ld	s1,8(sp)
    80001422:	6105                	addi	sp,sp,32
    80001424:	8082                	ret

0000000080001426 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001426:	7179                	addi	sp,sp,-48
    80001428:	f406                	sd	ra,40(sp)
    8000142a:	f022                	sd	s0,32(sp)
    8000142c:	ec26                	sd	s1,24(sp)
    8000142e:	e84a                	sd	s2,16(sp)
    80001430:	e44e                	sd	s3,8(sp)
    80001432:	1800                	addi	s0,sp,48
    80001434:	89aa                	mv	s3,a0
    80001436:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001438:	a21ff0ef          	jal	80000e58 <myproc>
    8000143c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000143e:	506040ef          	jal	80005944 <acquire>
  release(lk);
    80001442:	854a                	mv	a0,s2
    80001444:	594040ef          	jal	800059d8 <release>

  // Go to sleep.
  p->chan = chan;
    80001448:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000144c:	4789                	li	a5,2
    8000144e:	cc9c                	sw	a5,24(s1)

  sched();
    80001450:	ef1ff0ef          	jal	80001340 <sched>

  // Tidy up.
  p->chan = 0;
    80001454:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001458:	8526                	mv	a0,s1
    8000145a:	57e040ef          	jal	800059d8 <release>
  acquire(lk);
    8000145e:	854a                	mv	a0,s2
    80001460:	4e4040ef          	jal	80005944 <acquire>
}
    80001464:	70a2                	ld	ra,40(sp)
    80001466:	7402                	ld	s0,32(sp)
    80001468:	64e2                	ld	s1,24(sp)
    8000146a:	6942                	ld	s2,16(sp)
    8000146c:	69a2                	ld	s3,8(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001472:	7139                	addi	sp,sp,-64
    80001474:	fc06                	sd	ra,56(sp)
    80001476:	f822                	sd	s0,48(sp)
    80001478:	f426                	sd	s1,40(sp)
    8000147a:	f04a                	sd	s2,32(sp)
    8000147c:	ec4e                	sd	s3,24(sp)
    8000147e:	e852                	sd	s4,16(sp)
    80001480:	e456                	sd	s5,8(sp)
    80001482:	0080                	addi	s0,sp,64
    80001484:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001486:	00009497          	auipc	s1,0x9
    8000148a:	47a48493          	addi	s1,s1,1146 # 8000a900 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000148e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001490:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001492:	0000f917          	auipc	s2,0xf
    80001496:	e6e90913          	addi	s2,s2,-402 # 80010300 <tickslock>
    8000149a:	a801                	j	800014aa <wakeup+0x38>
      }
      release(&p->lock);
    8000149c:	8526                	mv	a0,s1
    8000149e:	53a040ef          	jal	800059d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014a2:	16848493          	addi	s1,s1,360
    800014a6:	03248263          	beq	s1,s2,800014ca <wakeup+0x58>
    if(p != myproc()){
    800014aa:	9afff0ef          	jal	80000e58 <myproc>
    800014ae:	fea48ae3          	beq	s1,a0,800014a2 <wakeup+0x30>
      acquire(&p->lock);
    800014b2:	8526                	mv	a0,s1
    800014b4:	490040ef          	jal	80005944 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800014b8:	4c9c                	lw	a5,24(s1)
    800014ba:	ff3791e3          	bne	a5,s3,8000149c <wakeup+0x2a>
    800014be:	709c                	ld	a5,32(s1)
    800014c0:	fd479ee3          	bne	a5,s4,8000149c <wakeup+0x2a>
        p->state = RUNNABLE;
    800014c4:	0154ac23          	sw	s5,24(s1)
    800014c8:	bfd1                	j	8000149c <wakeup+0x2a>
    }
  }
}
    800014ca:	70e2                	ld	ra,56(sp)
    800014cc:	7442                	ld	s0,48(sp)
    800014ce:	74a2                	ld	s1,40(sp)
    800014d0:	7902                	ld	s2,32(sp)
    800014d2:	69e2                	ld	s3,24(sp)
    800014d4:	6a42                	ld	s4,16(sp)
    800014d6:	6aa2                	ld	s5,8(sp)
    800014d8:	6121                	addi	sp,sp,64
    800014da:	8082                	ret

00000000800014dc <reparent>:
{
    800014dc:	7179                	addi	sp,sp,-48
    800014de:	f406                	sd	ra,40(sp)
    800014e0:	f022                	sd	s0,32(sp)
    800014e2:	ec26                	sd	s1,24(sp)
    800014e4:	e84a                	sd	s2,16(sp)
    800014e6:	e44e                	sd	s3,8(sp)
    800014e8:	e052                	sd	s4,0(sp)
    800014ea:	1800                	addi	s0,sp,48
    800014ec:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014ee:	00009497          	auipc	s1,0x9
    800014f2:	41248493          	addi	s1,s1,1042 # 8000a900 <proc>
      pp->parent = initproc;
    800014f6:	00009a17          	auipc	s4,0x9
    800014fa:	f9aa0a13          	addi	s4,s4,-102 # 8000a490 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014fe:	0000f997          	auipc	s3,0xf
    80001502:	e0298993          	addi	s3,s3,-510 # 80010300 <tickslock>
    80001506:	a029                	j	80001510 <reparent+0x34>
    80001508:	16848493          	addi	s1,s1,360
    8000150c:	01348b63          	beq	s1,s3,80001522 <reparent+0x46>
    if(pp->parent == p){
    80001510:	7c9c                	ld	a5,56(s1)
    80001512:	ff279be3          	bne	a5,s2,80001508 <reparent+0x2c>
      pp->parent = initproc;
    80001516:	000a3503          	ld	a0,0(s4)
    8000151a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000151c:	f57ff0ef          	jal	80001472 <wakeup>
    80001520:	b7e5                	j	80001508 <reparent+0x2c>
}
    80001522:	70a2                	ld	ra,40(sp)
    80001524:	7402                	ld	s0,32(sp)
    80001526:	64e2                	ld	s1,24(sp)
    80001528:	6942                	ld	s2,16(sp)
    8000152a:	69a2                	ld	s3,8(sp)
    8000152c:	6a02                	ld	s4,0(sp)
    8000152e:	6145                	addi	sp,sp,48
    80001530:	8082                	ret

0000000080001532 <exit>:
{
    80001532:	7179                	addi	sp,sp,-48
    80001534:	f406                	sd	ra,40(sp)
    80001536:	f022                	sd	s0,32(sp)
    80001538:	ec26                	sd	s1,24(sp)
    8000153a:	e84a                	sd	s2,16(sp)
    8000153c:	e44e                	sd	s3,8(sp)
    8000153e:	e052                	sd	s4,0(sp)
    80001540:	1800                	addi	s0,sp,48
    80001542:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001544:	915ff0ef          	jal	80000e58 <myproc>
    80001548:	89aa                	mv	s3,a0
  if(p == initproc)
    8000154a:	00009797          	auipc	a5,0x9
    8000154e:	f467b783          	ld	a5,-186(a5) # 8000a490 <initproc>
    80001552:	0d050493          	addi	s1,a0,208
    80001556:	15050913          	addi	s2,a0,336
    8000155a:	00a79b63          	bne	a5,a0,80001570 <exit+0x3e>
    panic("init exiting");
    8000155e:	00006517          	auipc	a0,0x6
    80001562:	d0250513          	addi	a0,a0,-766 # 80007260 <etext+0x260>
    80001566:	0b0040ef          	jal	80005616 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000156a:	04a1                	addi	s1,s1,8
    8000156c:	01248963          	beq	s1,s2,8000157e <exit+0x4c>
    if(p->ofile[fd]){
    80001570:	6088                	ld	a0,0(s1)
    80001572:	dd65                	beqz	a0,8000156a <exit+0x38>
      fileclose(f);
    80001574:	783010ef          	jal	800034f6 <fileclose>
      p->ofile[fd] = 0;
    80001578:	0004b023          	sd	zero,0(s1)
    8000157c:	b7fd                	j	8000156a <exit+0x38>
  begin_op();
    8000157e:	359010ef          	jal	800030d6 <begin_op>
  iput(p->cwd);
    80001582:	1509b503          	ld	a0,336(s3)
    80001586:	420010ef          	jal	800029a6 <iput>
  end_op();
    8000158a:	3b7010ef          	jal	80003140 <end_op>
  p->cwd = 0;
    8000158e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001592:	00009497          	auipc	s1,0x9
    80001596:	f5648493          	addi	s1,s1,-170 # 8000a4e8 <wait_lock>
    8000159a:	8526                	mv	a0,s1
    8000159c:	3a8040ef          	jal	80005944 <acquire>
  reparent(p);
    800015a0:	854e                	mv	a0,s3
    800015a2:	f3bff0ef          	jal	800014dc <reparent>
  wakeup(p->parent);
    800015a6:	0389b503          	ld	a0,56(s3)
    800015aa:	ec9ff0ef          	jal	80001472 <wakeup>
  acquire(&p->lock);
    800015ae:	854e                	mv	a0,s3
    800015b0:	394040ef          	jal	80005944 <acquire>
  p->xstate = status;
    800015b4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800015b8:	4795                	li	a5,5
    800015ba:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	418040ef          	jal	800059d8 <release>
  sched();
    800015c4:	d7dff0ef          	jal	80001340 <sched>
  panic("zombie exit");
    800015c8:	00006517          	auipc	a0,0x6
    800015cc:	ca850513          	addi	a0,a0,-856 # 80007270 <etext+0x270>
    800015d0:	046040ef          	jal	80005616 <panic>

00000000800015d4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	ec26                	sd	s1,24(sp)
    800015dc:	e84a                	sd	s2,16(sp)
    800015de:	e44e                	sd	s3,8(sp)
    800015e0:	1800                	addi	s0,sp,48
    800015e2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800015e4:	00009497          	auipc	s1,0x9
    800015e8:	31c48493          	addi	s1,s1,796 # 8000a900 <proc>
    800015ec:	0000f997          	auipc	s3,0xf
    800015f0:	d1498993          	addi	s3,s3,-748 # 80010300 <tickslock>
    acquire(&p->lock);
    800015f4:	8526                	mv	a0,s1
    800015f6:	34e040ef          	jal	80005944 <acquire>
    if(p->pid == pid){
    800015fa:	589c                	lw	a5,48(s1)
    800015fc:	01278b63          	beq	a5,s2,80001612 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	3d6040ef          	jal	800059d8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001606:	16848493          	addi	s1,s1,360
    8000160a:	ff3495e3          	bne	s1,s3,800015f4 <kill+0x20>
  }
  return -1;
    8000160e:	557d                	li	a0,-1
    80001610:	a819                	j	80001626 <kill+0x52>
      p->killed = 1;
    80001612:	4785                	li	a5,1
    80001614:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001616:	4c98                	lw	a4,24(s1)
    80001618:	4789                	li	a5,2
    8000161a:	00f70d63          	beq	a4,a5,80001634 <kill+0x60>
      release(&p->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	3b8040ef          	jal	800059d8 <release>
      return 0;
    80001624:	4501                	li	a0,0
}
    80001626:	70a2                	ld	ra,40(sp)
    80001628:	7402                	ld	s0,32(sp)
    8000162a:	64e2                	ld	s1,24(sp)
    8000162c:	6942                	ld	s2,16(sp)
    8000162e:	69a2                	ld	s3,8(sp)
    80001630:	6145                	addi	sp,sp,48
    80001632:	8082                	ret
        p->state = RUNNABLE;
    80001634:	478d                	li	a5,3
    80001636:	cc9c                	sw	a5,24(s1)
    80001638:	b7dd                	j	8000161e <kill+0x4a>

000000008000163a <setkilled>:

void
setkilled(struct proc *p)
{
    8000163a:	1101                	addi	sp,sp,-32
    8000163c:	ec06                	sd	ra,24(sp)
    8000163e:	e822                	sd	s0,16(sp)
    80001640:	e426                	sd	s1,8(sp)
    80001642:	1000                	addi	s0,sp,32
    80001644:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001646:	2fe040ef          	jal	80005944 <acquire>
  p->killed = 1;
    8000164a:	4785                	li	a5,1
    8000164c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000164e:	8526                	mv	a0,s1
    80001650:	388040ef          	jal	800059d8 <release>
}
    80001654:	60e2                	ld	ra,24(sp)
    80001656:	6442                	ld	s0,16(sp)
    80001658:	64a2                	ld	s1,8(sp)
    8000165a:	6105                	addi	sp,sp,32
    8000165c:	8082                	ret

000000008000165e <killed>:

int
killed(struct proc *p)
{
    8000165e:	1101                	addi	sp,sp,-32
    80001660:	ec06                	sd	ra,24(sp)
    80001662:	e822                	sd	s0,16(sp)
    80001664:	e426                	sd	s1,8(sp)
    80001666:	e04a                	sd	s2,0(sp)
    80001668:	1000                	addi	s0,sp,32
    8000166a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000166c:	2d8040ef          	jal	80005944 <acquire>
  k = p->killed;
    80001670:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001674:	8526                	mv	a0,s1
    80001676:	362040ef          	jal	800059d8 <release>
  return k;
}
    8000167a:	854a                	mv	a0,s2
    8000167c:	60e2                	ld	ra,24(sp)
    8000167e:	6442                	ld	s0,16(sp)
    80001680:	64a2                	ld	s1,8(sp)
    80001682:	6902                	ld	s2,0(sp)
    80001684:	6105                	addi	sp,sp,32
    80001686:	8082                	ret

0000000080001688 <wait>:
{
    80001688:	715d                	addi	sp,sp,-80
    8000168a:	e486                	sd	ra,72(sp)
    8000168c:	e0a2                	sd	s0,64(sp)
    8000168e:	fc26                	sd	s1,56(sp)
    80001690:	f84a                	sd	s2,48(sp)
    80001692:	f44e                	sd	s3,40(sp)
    80001694:	f052                	sd	s4,32(sp)
    80001696:	ec56                	sd	s5,24(sp)
    80001698:	e85a                	sd	s6,16(sp)
    8000169a:	e45e                	sd	s7,8(sp)
    8000169c:	0880                	addi	s0,sp,80
    8000169e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016a0:	fb8ff0ef          	jal	80000e58 <myproc>
    800016a4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016a6:	00009517          	auipc	a0,0x9
    800016aa:	e4250513          	addi	a0,a0,-446 # 8000a4e8 <wait_lock>
    800016ae:	296040ef          	jal	80005944 <acquire>
        if(pp->state == ZOMBIE){
    800016b2:	4a15                	li	s4,5
        havekids = 1;
    800016b4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b6:	0000f997          	auipc	s3,0xf
    800016ba:	c4a98993          	addi	s3,s3,-950 # 80010300 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016be:	00009b97          	auipc	s7,0x9
    800016c2:	e2ab8b93          	addi	s7,s7,-470 # 8000a4e8 <wait_lock>
    800016c6:	a869                	j	80001760 <wait+0xd8>
          pid = pp->pid;
    800016c8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800016cc:	000b0c63          	beqz	s6,800016e4 <wait+0x5c>
    800016d0:	4691                	li	a3,4
    800016d2:	02c48613          	addi	a2,s1,44
    800016d6:	85da                	mv	a1,s6
    800016d8:	05093503          	ld	a0,80(s2)
    800016dc:	b42ff0ef          	jal	80000a1e <copyout>
    800016e0:	02054a63          	bltz	a0,80001714 <wait+0x8c>
          freeproc(pp);
    800016e4:	8526                	mv	a0,s1
    800016e6:	8e5ff0ef          	jal	80000fca <freeproc>
          release(&pp->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	2ec040ef          	jal	800059d8 <release>
          release(&wait_lock);
    800016f0:	00009517          	auipc	a0,0x9
    800016f4:	df850513          	addi	a0,a0,-520 # 8000a4e8 <wait_lock>
    800016f8:	2e0040ef          	jal	800059d8 <release>
}
    800016fc:	854e                	mv	a0,s3
    800016fe:	60a6                	ld	ra,72(sp)
    80001700:	6406                	ld	s0,64(sp)
    80001702:	74e2                	ld	s1,56(sp)
    80001704:	7942                	ld	s2,48(sp)
    80001706:	79a2                	ld	s3,40(sp)
    80001708:	7a02                	ld	s4,32(sp)
    8000170a:	6ae2                	ld	s5,24(sp)
    8000170c:	6b42                	ld	s6,16(sp)
    8000170e:	6ba2                	ld	s7,8(sp)
    80001710:	6161                	addi	sp,sp,80
    80001712:	8082                	ret
            release(&pp->lock);
    80001714:	8526                	mv	a0,s1
    80001716:	2c2040ef          	jal	800059d8 <release>
            release(&wait_lock);
    8000171a:	00009517          	auipc	a0,0x9
    8000171e:	dce50513          	addi	a0,a0,-562 # 8000a4e8 <wait_lock>
    80001722:	2b6040ef          	jal	800059d8 <release>
            return -1;
    80001726:	59fd                	li	s3,-1
    80001728:	bfd1                	j	800016fc <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000172a:	16848493          	addi	s1,s1,360
    8000172e:	03348063          	beq	s1,s3,8000174e <wait+0xc6>
      if(pp->parent == p){
    80001732:	7c9c                	ld	a5,56(s1)
    80001734:	ff279be3          	bne	a5,s2,8000172a <wait+0xa2>
        acquire(&pp->lock);
    80001738:	8526                	mv	a0,s1
    8000173a:	20a040ef          	jal	80005944 <acquire>
        if(pp->state == ZOMBIE){
    8000173e:	4c9c                	lw	a5,24(s1)
    80001740:	f94784e3          	beq	a5,s4,800016c8 <wait+0x40>
        release(&pp->lock);
    80001744:	8526                	mv	a0,s1
    80001746:	292040ef          	jal	800059d8 <release>
        havekids = 1;
    8000174a:	8756                	mv	a4,s5
    8000174c:	bff9                	j	8000172a <wait+0xa2>
    if(!havekids || killed(p)){
    8000174e:	cf19                	beqz	a4,8000176c <wait+0xe4>
    80001750:	854a                	mv	a0,s2
    80001752:	f0dff0ef          	jal	8000165e <killed>
    80001756:	e919                	bnez	a0,8000176c <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001758:	85de                	mv	a1,s7
    8000175a:	854a                	mv	a0,s2
    8000175c:	ccbff0ef          	jal	80001426 <sleep>
    havekids = 0;
    80001760:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001762:	00009497          	auipc	s1,0x9
    80001766:	19e48493          	addi	s1,s1,414 # 8000a900 <proc>
    8000176a:	b7e1                	j	80001732 <wait+0xaa>
      release(&wait_lock);
    8000176c:	00009517          	auipc	a0,0x9
    80001770:	d7c50513          	addi	a0,a0,-644 # 8000a4e8 <wait_lock>
    80001774:	264040ef          	jal	800059d8 <release>
      return -1;
    80001778:	59fd                	li	s3,-1
    8000177a:	b749                	j	800016fc <wait+0x74>

000000008000177c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000177c:	7179                	addi	sp,sp,-48
    8000177e:	f406                	sd	ra,40(sp)
    80001780:	f022                	sd	s0,32(sp)
    80001782:	ec26                	sd	s1,24(sp)
    80001784:	e84a                	sd	s2,16(sp)
    80001786:	e44e                	sd	s3,8(sp)
    80001788:	e052                	sd	s4,0(sp)
    8000178a:	1800                	addi	s0,sp,48
    8000178c:	84aa                	mv	s1,a0
    8000178e:	892e                	mv	s2,a1
    80001790:	89b2                	mv	s3,a2
    80001792:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001794:	ec4ff0ef          	jal	80000e58 <myproc>
  if(user_dst){
    80001798:	cc99                	beqz	s1,800017b6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000179a:	86d2                	mv	a3,s4
    8000179c:	864e                	mv	a2,s3
    8000179e:	85ca                	mv	a1,s2
    800017a0:	6928                	ld	a0,80(a0)
    800017a2:	a7cff0ef          	jal	80000a1e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6a02                	ld	s4,0(sp)
    800017b2:	6145                	addi	sp,sp,48
    800017b4:	8082                	ret
    memmove((char *)dst, src, len);
    800017b6:	000a061b          	sext.w	a2,s4
    800017ba:	85ce                	mv	a1,s3
    800017bc:	854a                	mv	a0,s2
    800017be:	9f5fe0ef          	jal	800001b2 <memmove>
    return 0;
    800017c2:	8526                	mv	a0,s1
    800017c4:	b7cd                	j	800017a6 <either_copyout+0x2a>

00000000800017c6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800017c6:	7179                	addi	sp,sp,-48
    800017c8:	f406                	sd	ra,40(sp)
    800017ca:	f022                	sd	s0,32(sp)
    800017cc:	ec26                	sd	s1,24(sp)
    800017ce:	e84a                	sd	s2,16(sp)
    800017d0:	e44e                	sd	s3,8(sp)
    800017d2:	e052                	sd	s4,0(sp)
    800017d4:	1800                	addi	s0,sp,48
    800017d6:	892a                	mv	s2,a0
    800017d8:	84ae                	mv	s1,a1
    800017da:	89b2                	mv	s3,a2
    800017dc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017de:	e7aff0ef          	jal	80000e58 <myproc>
  if(user_src){
    800017e2:	cc99                	beqz	s1,80001800 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800017e4:	86d2                	mv	a3,s4
    800017e6:	864e                	mv	a2,s3
    800017e8:	85ca                	mv	a1,s2
    800017ea:	6928                	ld	a0,80(a0)
    800017ec:	ae2ff0ef          	jal	80000ace <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800017f0:	70a2                	ld	ra,40(sp)
    800017f2:	7402                	ld	s0,32(sp)
    800017f4:	64e2                	ld	s1,24(sp)
    800017f6:	6942                	ld	s2,16(sp)
    800017f8:	69a2                	ld	s3,8(sp)
    800017fa:	6a02                	ld	s4,0(sp)
    800017fc:	6145                	addi	sp,sp,48
    800017fe:	8082                	ret
    memmove(dst, (char*)src, len);
    80001800:	000a061b          	sext.w	a2,s4
    80001804:	85ce                	mv	a1,s3
    80001806:	854a                	mv	a0,s2
    80001808:	9abfe0ef          	jal	800001b2 <memmove>
    return 0;
    8000180c:	8526                	mv	a0,s1
    8000180e:	b7cd                	j	800017f0 <either_copyin+0x2a>

0000000080001810 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001810:	715d                	addi	sp,sp,-80
    80001812:	e486                	sd	ra,72(sp)
    80001814:	e0a2                	sd	s0,64(sp)
    80001816:	fc26                	sd	s1,56(sp)
    80001818:	f84a                	sd	s2,48(sp)
    8000181a:	f44e                	sd	s3,40(sp)
    8000181c:	f052                	sd	s4,32(sp)
    8000181e:	ec56                	sd	s5,24(sp)
    80001820:	e85a                	sd	s6,16(sp)
    80001822:	e45e                	sd	s7,8(sp)
    80001824:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001826:	00005517          	auipc	a0,0x5
    8000182a:	7f250513          	addi	a0,a0,2034 # 80007018 <etext+0x18>
    8000182e:	319030ef          	jal	80005346 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001832:	00009497          	auipc	s1,0x9
    80001836:	22648493          	addi	s1,s1,550 # 8000aa58 <proc+0x158>
    8000183a:	0000f917          	auipc	s2,0xf
    8000183e:	c1e90913          	addi	s2,s2,-994 # 80010458 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001842:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001844:	00006997          	auipc	s3,0x6
    80001848:	a3c98993          	addi	s3,s3,-1476 # 80007280 <etext+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    8000184c:	00006a97          	auipc	s5,0x6
    80001850:	a3ca8a93          	addi	s5,s5,-1476 # 80007288 <etext+0x288>
    printf("\n");
    80001854:	00005a17          	auipc	s4,0x5
    80001858:	7c4a0a13          	addi	s4,s4,1988 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000185c:	00006b97          	auipc	s7,0x6
    80001860:	f54b8b93          	addi	s7,s7,-172 # 800077b0 <states.0>
    80001864:	a829                	j	8000187e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001866:	ed86a583          	lw	a1,-296(a3)
    8000186a:	8556                	mv	a0,s5
    8000186c:	2db030ef          	jal	80005346 <printf>
    printf("\n");
    80001870:	8552                	mv	a0,s4
    80001872:	2d5030ef          	jal	80005346 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001876:	16848493          	addi	s1,s1,360
    8000187a:	03248263          	beq	s1,s2,8000189e <procdump+0x8e>
    if(p->state == UNUSED)
    8000187e:	86a6                	mv	a3,s1
    80001880:	ec04a783          	lw	a5,-320(s1)
    80001884:	dbed                	beqz	a5,80001876 <procdump+0x66>
      state = "???";
    80001886:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001888:	fcfb6fe3          	bltu	s6,a5,80001866 <procdump+0x56>
    8000188c:	02079713          	slli	a4,a5,0x20
    80001890:	01d75793          	srli	a5,a4,0x1d
    80001894:	97de                	add	a5,a5,s7
    80001896:	6390                	ld	a2,0(a5)
    80001898:	f679                	bnez	a2,80001866 <procdump+0x56>
      state = "???";
    8000189a:	864e                	mv	a2,s3
    8000189c:	b7e9                	j	80001866 <procdump+0x56>
  }
}
    8000189e:	60a6                	ld	ra,72(sp)
    800018a0:	6406                	ld	s0,64(sp)
    800018a2:	74e2                	ld	s1,56(sp)
    800018a4:	7942                	ld	s2,48(sp)
    800018a6:	79a2                	ld	s3,40(sp)
    800018a8:	7a02                	ld	s4,32(sp)
    800018aa:	6ae2                	ld	s5,24(sp)
    800018ac:	6b42                	ld	s6,16(sp)
    800018ae:	6ba2                	ld	s7,8(sp)
    800018b0:	6161                	addi	sp,sp,80
    800018b2:	8082                	ret

00000000800018b4 <swtch>:
    800018b4:	00153023          	sd	ra,0(a0)
    800018b8:	00253423          	sd	sp,8(a0)
    800018bc:	e900                	sd	s0,16(a0)
    800018be:	ed04                	sd	s1,24(a0)
    800018c0:	03253023          	sd	s2,32(a0)
    800018c4:	03353423          	sd	s3,40(a0)
    800018c8:	03453823          	sd	s4,48(a0)
    800018cc:	03553c23          	sd	s5,56(a0)
    800018d0:	05653023          	sd	s6,64(a0)
    800018d4:	05753423          	sd	s7,72(a0)
    800018d8:	05853823          	sd	s8,80(a0)
    800018dc:	05953c23          	sd	s9,88(a0)
    800018e0:	07a53023          	sd	s10,96(a0)
    800018e4:	07b53423          	sd	s11,104(a0)
    800018e8:	0005b083          	ld	ra,0(a1)
    800018ec:	0085b103          	ld	sp,8(a1)
    800018f0:	6980                	ld	s0,16(a1)
    800018f2:	6d84                	ld	s1,24(a1)
    800018f4:	0205b903          	ld	s2,32(a1)
    800018f8:	0285b983          	ld	s3,40(a1)
    800018fc:	0305ba03          	ld	s4,48(a1)
    80001900:	0385ba83          	ld	s5,56(a1)
    80001904:	0405bb03          	ld	s6,64(a1)
    80001908:	0485bb83          	ld	s7,72(a1)
    8000190c:	0505bc03          	ld	s8,80(a1)
    80001910:	0585bc83          	ld	s9,88(a1)
    80001914:	0605bd03          	ld	s10,96(a1)
    80001918:	0685bd83          	ld	s11,104(a1)
    8000191c:	8082                	ret

000000008000191e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000191e:	1141                	addi	sp,sp,-16
    80001920:	e406                	sd	ra,8(sp)
    80001922:	e022                	sd	s0,0(sp)
    80001924:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001926:	00006597          	auipc	a1,0x6
    8000192a:	9a258593          	addi	a1,a1,-1630 # 800072c8 <etext+0x2c8>
    8000192e:	0000f517          	auipc	a0,0xf
    80001932:	9d250513          	addi	a0,a0,-1582 # 80010300 <tickslock>
    80001936:	78b030ef          	jal	800058c0 <initlock>
}
    8000193a:	60a2                	ld	ra,8(sp)
    8000193c:	6402                	ld	s0,0(sp)
    8000193e:	0141                	addi	sp,sp,16
    80001940:	8082                	ret

0000000080001942 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001942:	1141                	addi	sp,sp,-16
    80001944:	e406                	sd	ra,8(sp)
    80001946:	e022                	sd	s0,0(sp)
    80001948:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000194a:	00003797          	auipc	a5,0x3
    8000194e:	f6678793          	addi	a5,a5,-154 # 800048b0 <kernelvec>
    80001952:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001956:	60a2                	ld	ra,8(sp)
    80001958:	6402                	ld	s0,0(sp)
    8000195a:	0141                	addi	sp,sp,16
    8000195c:	8082                	ret

000000008000195e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000195e:	1141                	addi	sp,sp,-16
    80001960:	e406                	sd	ra,8(sp)
    80001962:	e022                	sd	s0,0(sp)
    80001964:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001966:	cf2ff0ef          	jal	80000e58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000196a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000196e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001970:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001974:	00004697          	auipc	a3,0x4
    80001978:	68c68693          	addi	a3,a3,1676 # 80006000 <_trampoline>
    8000197c:	00004717          	auipc	a4,0x4
    80001980:	68470713          	addi	a4,a4,1668 # 80006000 <_trampoline>
    80001984:	8f15                	sub	a4,a4,a3
    80001986:	040007b7          	lui	a5,0x4000
    8000198a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000198c:	07b2                	slli	a5,a5,0xc
    8000198e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001990:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001994:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001996:	18002673          	csrr	a2,satp
    8000199a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000199c:	6d30                	ld	a2,88(a0)
    8000199e:	6138                	ld	a4,64(a0)
    800019a0:	6585                	lui	a1,0x1
    800019a2:	972e                	add	a4,a4,a1
    800019a4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019a6:	6d38                	ld	a4,88(a0)
    800019a8:	00000617          	auipc	a2,0x0
    800019ac:	11060613          	addi	a2,a2,272 # 80001ab8 <usertrap>
    800019b0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800019b2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800019b4:	8612                	mv	a2,tp
    800019b6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019b8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800019bc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800019c0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019c4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800019c8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800019ca:	6f18                	ld	a4,24(a4)
    800019cc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800019d0:	6928                	ld	a0,80(a0)
    800019d2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019d4:	00004717          	auipc	a4,0x4
    800019d8:	6c870713          	addi	a4,a4,1736 # 8000609c <userret>
    800019dc:	8f15                	sub	a4,a4,a3
    800019de:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019e0:	577d                	li	a4,-1
    800019e2:	177e                	slli	a4,a4,0x3f
    800019e4:	8d59                	or	a0,a0,a4
    800019e6:	9782                	jalr	a5
}
    800019e8:	60a2                	ld	ra,8(sp)
    800019ea:	6402                	ld	s0,0(sp)
    800019ec:	0141                	addi	sp,sp,16
    800019ee:	8082                	ret

00000000800019f0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800019f0:	1101                	addi	sp,sp,-32
    800019f2:	ec06                	sd	ra,24(sp)
    800019f4:	e822                	sd	s0,16(sp)
    800019f6:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800019f8:	c2cff0ef          	jal	80000e24 <cpuid>
    800019fc:	cd11                	beqz	a0,80001a18 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019fe:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001a02:	000f4737          	lui	a4,0xf4
    80001a06:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a0a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a0c:	14d79073          	csrw	stimecmp,a5
}
    80001a10:	60e2                	ld	ra,24(sp)
    80001a12:	6442                	ld	s0,16(sp)
    80001a14:	6105                	addi	sp,sp,32
    80001a16:	8082                	ret
    80001a18:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001a1a:	0000f497          	auipc	s1,0xf
    80001a1e:	8e648493          	addi	s1,s1,-1818 # 80010300 <tickslock>
    80001a22:	8526                	mv	a0,s1
    80001a24:	721030ef          	jal	80005944 <acquire>
    ticks++;
    80001a28:	00009517          	auipc	a0,0x9
    80001a2c:	a7050513          	addi	a0,a0,-1424 # 8000a498 <ticks>
    80001a30:	411c                	lw	a5,0(a0)
    80001a32:	2785                	addiw	a5,a5,1
    80001a34:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001a36:	a3dff0ef          	jal	80001472 <wakeup>
    release(&tickslock);
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	79d030ef          	jal	800059d8 <release>
    80001a40:	64a2                	ld	s1,8(sp)
    80001a42:	bf75                	j	800019fe <clockintr+0xe>

0000000080001a44 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a44:	1101                	addi	sp,sp,-32
    80001a46:	ec06                	sd	ra,24(sp)
    80001a48:	e822                	sd	s0,16(sp)
    80001a4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a4c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a50:	57fd                	li	a5,-1
    80001a52:	17fe                	slli	a5,a5,0x3f
    80001a54:	07a5                	addi	a5,a5,9
    80001a56:	00f70c63          	beq	a4,a5,80001a6e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a5a:	57fd                	li	a5,-1
    80001a5c:	17fe                	slli	a5,a5,0x3f
    80001a5e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a60:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a62:	04f70763          	beq	a4,a5,80001ab0 <devintr+0x6c>
  }
}
    80001a66:	60e2                	ld	ra,24(sp)
    80001a68:	6442                	ld	s0,16(sp)
    80001a6a:	6105                	addi	sp,sp,32
    80001a6c:	8082                	ret
    80001a6e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a70:	6ed020ef          	jal	8000495c <plic_claim>
    80001a74:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a76:	47a9                	li	a5,10
    80001a78:	00f50963          	beq	a0,a5,80001a8a <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a7c:	4785                	li	a5,1
    80001a7e:	00f50963          	beq	a0,a5,80001a90 <devintr+0x4c>
    return 1;
    80001a82:	4505                	li	a0,1
    } else if(irq){
    80001a84:	e889                	bnez	s1,80001a96 <devintr+0x52>
    80001a86:	64a2                	ld	s1,8(sp)
    80001a88:	bff9                	j	80001a66 <devintr+0x22>
      uartintr();
    80001a8a:	5fb030ef          	jal	80005884 <uartintr>
    if(irq)
    80001a8e:	a819                	j	80001aa4 <devintr+0x60>
      virtio_disk_intr();
    80001a90:	35c030ef          	jal	80004dec <virtio_disk_intr>
    if(irq)
    80001a94:	a801                	j	80001aa4 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a96:	85a6                	mv	a1,s1
    80001a98:	00006517          	auipc	a0,0x6
    80001a9c:	83850513          	addi	a0,a0,-1992 # 800072d0 <etext+0x2d0>
    80001aa0:	0a7030ef          	jal	80005346 <printf>
      plic_complete(irq);
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	6d7020ef          	jal	8000497c <plic_complete>
    return 1;
    80001aaa:	4505                	li	a0,1
    80001aac:	64a2                	ld	s1,8(sp)
    80001aae:	bf65                	j	80001a66 <devintr+0x22>
    clockintr();
    80001ab0:	f41ff0ef          	jal	800019f0 <clockintr>
    return 2;
    80001ab4:	4509                	li	a0,2
    80001ab6:	bf45                	j	80001a66 <devintr+0x22>

0000000080001ab8 <usertrap>:
{
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	e04a                	sd	s2,0(sp)
    80001ac2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ac8:	1007f793          	andi	a5,a5,256
    80001acc:	ef85                	bnez	a5,80001b04 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ace:	00003797          	auipc	a5,0x3
    80001ad2:	de278793          	addi	a5,a5,-542 # 800048b0 <kernelvec>
    80001ad6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ada:	b7eff0ef          	jal	80000e58 <myproc>
    80001ade:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ae0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ae2:	14102773          	csrr	a4,sepc
    80001ae6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ae8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001aec:	47a1                	li	a5,8
    80001aee:	02f70163          	beq	a4,a5,80001b10 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001af2:	f53ff0ef          	jal	80001a44 <devintr>
    80001af6:	892a                	mv	s2,a0
    80001af8:	c135                	beqz	a0,80001b5c <usertrap+0xa4>
  if(killed(p))
    80001afa:	8526                	mv	a0,s1
    80001afc:	b63ff0ef          	jal	8000165e <killed>
    80001b00:	cd1d                	beqz	a0,80001b3e <usertrap+0x86>
    80001b02:	a81d                	j	80001b38 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001b04:	00005517          	auipc	a0,0x5
    80001b08:	7ec50513          	addi	a0,a0,2028 # 800072f0 <etext+0x2f0>
    80001b0c:	30b030ef          	jal	80005616 <panic>
    if(killed(p))
    80001b10:	b4fff0ef          	jal	8000165e <killed>
    80001b14:	e121                	bnez	a0,80001b54 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001b16:	6cb8                	ld	a4,88(s1)
    80001b18:	6f1c                	ld	a5,24(a4)
    80001b1a:	0791                	addi	a5,a5,4
    80001b1c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b22:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b26:	10079073          	csrw	sstatus,a5
    syscall();
    80001b2a:	240000ef          	jal	80001d6a <syscall>
  if(killed(p))
    80001b2e:	8526                	mv	a0,s1
    80001b30:	b2fff0ef          	jal	8000165e <killed>
    80001b34:	c901                	beqz	a0,80001b44 <usertrap+0x8c>
    80001b36:	4901                	li	s2,0
    exit(-1);
    80001b38:	557d                	li	a0,-1
    80001b3a:	9f9ff0ef          	jal	80001532 <exit>
  if(which_dev == 2)
    80001b3e:	4789                	li	a5,2
    80001b40:	04f90563          	beq	s2,a5,80001b8a <usertrap+0xd2>
  usertrapret();
    80001b44:	e1bff0ef          	jal	8000195e <usertrapret>
}
    80001b48:	60e2                	ld	ra,24(sp)
    80001b4a:	6442                	ld	s0,16(sp)
    80001b4c:	64a2                	ld	s1,8(sp)
    80001b4e:	6902                	ld	s2,0(sp)
    80001b50:	6105                	addi	sp,sp,32
    80001b52:	8082                	ret
      exit(-1);
    80001b54:	557d                	li	a0,-1
    80001b56:	9ddff0ef          	jal	80001532 <exit>
    80001b5a:	bf75                	j	80001b16 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b5c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b60:	5890                	lw	a2,48(s1)
    80001b62:	00005517          	auipc	a0,0x5
    80001b66:	7ae50513          	addi	a0,a0,1966 # 80007310 <etext+0x310>
    80001b6a:	7dc030ef          	jal	80005346 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b6e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b72:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b76:	00005517          	auipc	a0,0x5
    80001b7a:	7ca50513          	addi	a0,a0,1994 # 80007340 <etext+0x340>
    80001b7e:	7c8030ef          	jal	80005346 <printf>
    setkilled(p);
    80001b82:	8526                	mv	a0,s1
    80001b84:	ab7ff0ef          	jal	8000163a <setkilled>
    80001b88:	b75d                	j	80001b2e <usertrap+0x76>
    yield();
    80001b8a:	871ff0ef          	jal	800013fa <yield>
    80001b8e:	bf5d                	j	80001b44 <usertrap+0x8c>

0000000080001b90 <kerneltrap>:
{
    80001b90:	7179                	addi	sp,sp,-48
    80001b92:	f406                	sd	ra,40(sp)
    80001b94:	f022                	sd	s0,32(sp)
    80001b96:	ec26                	sd	s1,24(sp)
    80001b98:	e84a                	sd	s2,16(sp)
    80001b9a:	e44e                	sd	s3,8(sp)
    80001b9c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b9e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001baa:	1004f793          	andi	a5,s1,256
    80001bae:	c795                	beqz	a5,80001bda <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001bb4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001bb6:	eb85                	bnez	a5,80001be6 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001bb8:	e8dff0ef          	jal	80001a44 <devintr>
    80001bbc:	c91d                	beqz	a0,80001bf2 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001bbe:	4789                	li	a5,2
    80001bc0:	04f50a63          	beq	a0,a5,80001c14 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc8:	10049073          	csrw	sstatus,s1
}
    80001bcc:	70a2                	ld	ra,40(sp)
    80001bce:	7402                	ld	s0,32(sp)
    80001bd0:	64e2                	ld	s1,24(sp)
    80001bd2:	6942                	ld	s2,16(sp)
    80001bd4:	69a2                	ld	s3,8(sp)
    80001bd6:	6145                	addi	sp,sp,48
    80001bd8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bda:	00005517          	auipc	a0,0x5
    80001bde:	78e50513          	addi	a0,a0,1934 # 80007368 <etext+0x368>
    80001be2:	235030ef          	jal	80005616 <panic>
    panic("kerneltrap: interrupts enabled");
    80001be6:	00005517          	auipc	a0,0x5
    80001bea:	7aa50513          	addi	a0,a0,1962 # 80007390 <etext+0x390>
    80001bee:	229030ef          	jal	80005616 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bf2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001bf6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001bfa:	85ce                	mv	a1,s3
    80001bfc:	00005517          	auipc	a0,0x5
    80001c00:	7b450513          	addi	a0,a0,1972 # 800073b0 <etext+0x3b0>
    80001c04:	742030ef          	jal	80005346 <printf>
    panic("kerneltrap");
    80001c08:	00005517          	auipc	a0,0x5
    80001c0c:	7d050513          	addi	a0,a0,2000 # 800073d8 <etext+0x3d8>
    80001c10:	207030ef          	jal	80005616 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c14:	a44ff0ef          	jal	80000e58 <myproc>
    80001c18:	d555                	beqz	a0,80001bc4 <kerneltrap+0x34>
    yield();
    80001c1a:	fe0ff0ef          	jal	800013fa <yield>
    80001c1e:	b75d                	j	80001bc4 <kerneltrap+0x34>

0000000080001c20 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c20:	1101                	addi	sp,sp,-32
    80001c22:	ec06                	sd	ra,24(sp)
    80001c24:	e822                	sd	s0,16(sp)
    80001c26:	e426                	sd	s1,8(sp)
    80001c28:	1000                	addi	s0,sp,32
    80001c2a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c2c:	a2cff0ef          	jal	80000e58 <myproc>
  switch (n) {
    80001c30:	4795                	li	a5,5
    80001c32:	0497e163          	bltu	a5,s1,80001c74 <argraw+0x54>
    80001c36:	048a                	slli	s1,s1,0x2
    80001c38:	00006717          	auipc	a4,0x6
    80001c3c:	ba870713          	addi	a4,a4,-1112 # 800077e0 <states.0+0x30>
    80001c40:	94ba                	add	s1,s1,a4
    80001c42:	409c                	lw	a5,0(s1)
    80001c44:	97ba                	add	a5,a5,a4
    80001c46:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c48:	6d3c                	ld	a5,88(a0)
    80001c4a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6105                	addi	sp,sp,32
    80001c54:	8082                	ret
    return p->trapframe->a1;
    80001c56:	6d3c                	ld	a5,88(a0)
    80001c58:	7fa8                	ld	a0,120(a5)
    80001c5a:	bfcd                	j	80001c4c <argraw+0x2c>
    return p->trapframe->a2;
    80001c5c:	6d3c                	ld	a5,88(a0)
    80001c5e:	63c8                	ld	a0,128(a5)
    80001c60:	b7f5                	j	80001c4c <argraw+0x2c>
    return p->trapframe->a3;
    80001c62:	6d3c                	ld	a5,88(a0)
    80001c64:	67c8                	ld	a0,136(a5)
    80001c66:	b7dd                	j	80001c4c <argraw+0x2c>
    return p->trapframe->a4;
    80001c68:	6d3c                	ld	a5,88(a0)
    80001c6a:	6bc8                	ld	a0,144(a5)
    80001c6c:	b7c5                	j	80001c4c <argraw+0x2c>
    return p->trapframe->a5;
    80001c6e:	6d3c                	ld	a5,88(a0)
    80001c70:	6fc8                	ld	a0,152(a5)
    80001c72:	bfe9                	j	80001c4c <argraw+0x2c>
  panic("argraw");
    80001c74:	00005517          	auipc	a0,0x5
    80001c78:	77450513          	addi	a0,a0,1908 # 800073e8 <etext+0x3e8>
    80001c7c:	19b030ef          	jal	80005616 <panic>

0000000080001c80 <fetchaddr>:
{
    80001c80:	1101                	addi	sp,sp,-32
    80001c82:	ec06                	sd	ra,24(sp)
    80001c84:	e822                	sd	s0,16(sp)
    80001c86:	e426                	sd	s1,8(sp)
    80001c88:	e04a                	sd	s2,0(sp)
    80001c8a:	1000                	addi	s0,sp,32
    80001c8c:	84aa                	mv	s1,a0
    80001c8e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c90:	9c8ff0ef          	jal	80000e58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c94:	653c                	ld	a5,72(a0)
    80001c96:	02f4f663          	bgeu	s1,a5,80001cc2 <fetchaddr+0x42>
    80001c9a:	00848713          	addi	a4,s1,8
    80001c9e:	02e7e463          	bltu	a5,a4,80001cc6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ca2:	46a1                	li	a3,8
    80001ca4:	8626                	mv	a2,s1
    80001ca6:	85ca                	mv	a1,s2
    80001ca8:	6928                	ld	a0,80(a0)
    80001caa:	e25fe0ef          	jal	80000ace <copyin>
    80001cae:	00a03533          	snez	a0,a0
    80001cb2:	40a0053b          	negw	a0,a0
}
    80001cb6:	60e2                	ld	ra,24(sp)
    80001cb8:	6442                	ld	s0,16(sp)
    80001cba:	64a2                	ld	s1,8(sp)
    80001cbc:	6902                	ld	s2,0(sp)
    80001cbe:	6105                	addi	sp,sp,32
    80001cc0:	8082                	ret
    return -1;
    80001cc2:	557d                	li	a0,-1
    80001cc4:	bfcd                	j	80001cb6 <fetchaddr+0x36>
    80001cc6:	557d                	li	a0,-1
    80001cc8:	b7fd                	j	80001cb6 <fetchaddr+0x36>

0000000080001cca <fetchstr>:
{
    80001cca:	7179                	addi	sp,sp,-48
    80001ccc:	f406                	sd	ra,40(sp)
    80001cce:	f022                	sd	s0,32(sp)
    80001cd0:	ec26                	sd	s1,24(sp)
    80001cd2:	e84a                	sd	s2,16(sp)
    80001cd4:	e44e                	sd	s3,8(sp)
    80001cd6:	1800                	addi	s0,sp,48
    80001cd8:	892a                	mv	s2,a0
    80001cda:	84ae                	mv	s1,a1
    80001cdc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cde:	97aff0ef          	jal	80000e58 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ce2:	86ce                	mv	a3,s3
    80001ce4:	864a                	mv	a2,s2
    80001ce6:	85a6                	mv	a1,s1
    80001ce8:	6928                	ld	a0,80(a0)
    80001cea:	e6bfe0ef          	jal	80000b54 <copyinstr>
    80001cee:	00054c63          	bltz	a0,80001d06 <fetchstr+0x3c>
  return strlen(buf);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	de2fe0ef          	jal	800002d6 <strlen>
}
    80001cf8:	70a2                	ld	ra,40(sp)
    80001cfa:	7402                	ld	s0,32(sp)
    80001cfc:	64e2                	ld	s1,24(sp)
    80001cfe:	6942                	ld	s2,16(sp)
    80001d00:	69a2                	ld	s3,8(sp)
    80001d02:	6145                	addi	sp,sp,48
    80001d04:	8082                	ret
    return -1;
    80001d06:	557d                	li	a0,-1
    80001d08:	bfc5                	j	80001cf8 <fetchstr+0x2e>

0000000080001d0a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d0a:	1101                	addi	sp,sp,-32
    80001d0c:	ec06                	sd	ra,24(sp)
    80001d0e:	e822                	sd	s0,16(sp)
    80001d10:	e426                	sd	s1,8(sp)
    80001d12:	1000                	addi	s0,sp,32
    80001d14:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d16:	f0bff0ef          	jal	80001c20 <argraw>
    80001d1a:	c088                	sw	a0,0(s1)
}
    80001d1c:	60e2                	ld	ra,24(sp)
    80001d1e:	6442                	ld	s0,16(sp)
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	6105                	addi	sp,sp,32
    80001d24:	8082                	ret

0000000080001d26 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d26:	1101                	addi	sp,sp,-32
    80001d28:	ec06                	sd	ra,24(sp)
    80001d2a:	e822                	sd	s0,16(sp)
    80001d2c:	e426                	sd	s1,8(sp)
    80001d2e:	1000                	addi	s0,sp,32
    80001d30:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d32:	eefff0ef          	jal	80001c20 <argraw>
    80001d36:	e088                	sd	a0,0(s1)
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret

0000000080001d42 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d42:	1101                	addi	sp,sp,-32
    80001d44:	ec06                	sd	ra,24(sp)
    80001d46:	e822                	sd	s0,16(sp)
    80001d48:	e426                	sd	s1,8(sp)
    80001d4a:	e04a                	sd	s2,0(sp)
    80001d4c:	1000                	addi	s0,sp,32
    80001d4e:	84ae                	mv	s1,a1
    80001d50:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001d52:	ecfff0ef          	jal	80001c20 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001d56:	864a                	mv	a2,s2
    80001d58:	85a6                	mv	a1,s1
    80001d5a:	f71ff0ef          	jal	80001cca <fetchstr>
}
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	64a2                	ld	s1,8(sp)
    80001d64:	6902                	ld	s2,0(sp)
    80001d66:	6105                	addi	sp,sp,32
    80001d68:	8082                	ret

0000000080001d6a <syscall>:



void
syscall(void)
{
    80001d6a:	1101                	addi	sp,sp,-32
    80001d6c:	ec06                	sd	ra,24(sp)
    80001d6e:	e822                	sd	s0,16(sp)
    80001d70:	e426                	sd	s1,8(sp)
    80001d72:	e04a                	sd	s2,0(sp)
    80001d74:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d76:	8e2ff0ef          	jal	80000e58 <myproc>
    80001d7a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d7c:	05853903          	ld	s2,88(a0)
    80001d80:	0a893783          	ld	a5,168(s2)
    80001d84:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d88:	37fd                	addiw	a5,a5,-1
    80001d8a:	02300713          	li	a4,35
    80001d8e:	00f76f63          	bltu	a4,a5,80001dac <syscall+0x42>
    80001d92:	00369713          	slli	a4,a3,0x3
    80001d96:	00006797          	auipc	a5,0x6
    80001d9a:	a6278793          	addi	a5,a5,-1438 # 800077f8 <syscalls>
    80001d9e:	97ba                	add	a5,a5,a4
    80001da0:	639c                	ld	a5,0(a5)
    80001da2:	c789                	beqz	a5,80001dac <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001da4:	9782                	jalr	a5
    80001da6:	06a93823          	sd	a0,112(s2)
    80001daa:	a829                	j	80001dc4 <syscall+0x5a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001dac:	15848613          	addi	a2,s1,344
    80001db0:	588c                	lw	a1,48(s1)
    80001db2:	00005517          	auipc	a0,0x5
    80001db6:	63e50513          	addi	a0,a0,1598 # 800073f0 <etext+0x3f0>
    80001dba:	58c030ef          	jal	80005346 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001dbe:	6cbc                	ld	a5,88(s1)
    80001dc0:	577d                	li	a4,-1
    80001dc2:	fbb8                	sd	a4,112(a5)
  }
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	6902                	ld	s2,0(sp)
    80001dcc:	6105                	addi	sp,sp,32
    80001dce:	8082                	ret

0000000080001dd0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001dd0:	1101                	addi	sp,sp,-32
    80001dd2:	ec06                	sd	ra,24(sp)
    80001dd4:	e822                	sd	s0,16(sp)
    80001dd6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001dd8:	fec40593          	addi	a1,s0,-20
    80001ddc:	4501                	li	a0,0
    80001dde:	f2dff0ef          	jal	80001d0a <argint>
  exit(n);
    80001de2:	fec42503          	lw	a0,-20(s0)
    80001de6:	f4cff0ef          	jal	80001532 <exit>
  return 0;  // not reached
}
    80001dea:	4501                	li	a0,0
    80001dec:	60e2                	ld	ra,24(sp)
    80001dee:	6442                	ld	s0,16(sp)
    80001df0:	6105                	addi	sp,sp,32
    80001df2:	8082                	ret

0000000080001df4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001df4:	1141                	addi	sp,sp,-16
    80001df6:	e406                	sd	ra,8(sp)
    80001df8:	e022                	sd	s0,0(sp)
    80001dfa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dfc:	85cff0ef          	jal	80000e58 <myproc>
}
    80001e00:	5908                	lw	a0,48(a0)
    80001e02:	60a2                	ld	ra,8(sp)
    80001e04:	6402                	ld	s0,0(sp)
    80001e06:	0141                	addi	sp,sp,16
    80001e08:	8082                	ret

0000000080001e0a <sys_fork>:

uint64
sys_fork(void)
{
    80001e0a:	1141                	addi	sp,sp,-16
    80001e0c:	e406                	sd	ra,8(sp)
    80001e0e:	e022                	sd	s0,0(sp)
    80001e10:	0800                	addi	s0,sp,16
  return fork();
    80001e12:	b6cff0ef          	jal	8000117e <fork>
}
    80001e16:	60a2                	ld	ra,8(sp)
    80001e18:	6402                	ld	s0,0(sp)
    80001e1a:	0141                	addi	sp,sp,16
    80001e1c:	8082                	ret

0000000080001e1e <sys_wait>:

uint64
sys_wait(void)
{
    80001e1e:	1101                	addi	sp,sp,-32
    80001e20:	ec06                	sd	ra,24(sp)
    80001e22:	e822                	sd	s0,16(sp)
    80001e24:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e26:	fe840593          	addi	a1,s0,-24
    80001e2a:	4501                	li	a0,0
    80001e2c:	efbff0ef          	jal	80001d26 <argaddr>
  return wait(p);
    80001e30:	fe843503          	ld	a0,-24(s0)
    80001e34:	855ff0ef          	jal	80001688 <wait>
}
    80001e38:	60e2                	ld	ra,24(sp)
    80001e3a:	6442                	ld	s0,16(sp)
    80001e3c:	6105                	addi	sp,sp,32
    80001e3e:	8082                	ret

0000000080001e40 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e40:	7179                	addi	sp,sp,-48
    80001e42:	f406                	sd	ra,40(sp)
    80001e44:	f022                	sd	s0,32(sp)
    80001e46:	ec26                	sd	s1,24(sp)
    80001e48:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e4a:	fdc40593          	addi	a1,s0,-36
    80001e4e:	4501                	li	a0,0
    80001e50:	ebbff0ef          	jal	80001d0a <argint>
  addr = myproc()->sz;
    80001e54:	804ff0ef          	jal	80000e58 <myproc>
    80001e58:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e5a:	fdc42503          	lw	a0,-36(s0)
    80001e5e:	ad0ff0ef          	jal	8000112e <growproc>
    80001e62:	00054863          	bltz	a0,80001e72 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e66:	8526                	mv	a0,s1
    80001e68:	70a2                	ld	ra,40(sp)
    80001e6a:	7402                	ld	s0,32(sp)
    80001e6c:	64e2                	ld	s1,24(sp)
    80001e6e:	6145                	addi	sp,sp,48
    80001e70:	8082                	ret
    return -1;
    80001e72:	54fd                	li	s1,-1
    80001e74:	bfcd                	j	80001e66 <sys_sbrk+0x26>

0000000080001e76 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e76:	7139                	addi	sp,sp,-64
    80001e78:	fc06                	sd	ra,56(sp)
    80001e7a:	f822                	sd	s0,48(sp)
    80001e7c:	f04a                	sd	s2,32(sp)
    80001e7e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80001e80:	fcc40593          	addi	a1,s0,-52
    80001e84:	4501                	li	a0,0
    80001e86:	e85ff0ef          	jal	80001d0a <argint>
  if(n < 0)
    80001e8a:	fcc42783          	lw	a5,-52(s0)
    80001e8e:	0607c763          	bltz	a5,80001efc <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e92:	0000e517          	auipc	a0,0xe
    80001e96:	46e50513          	addi	a0,a0,1134 # 80010300 <tickslock>
    80001e9a:	2ab030ef          	jal	80005944 <acquire>
  ticks0 = ticks;
    80001e9e:	00008917          	auipc	s2,0x8
    80001ea2:	5fa92903          	lw	s2,1530(s2) # 8000a498 <ticks>
  while(ticks - ticks0 < n){
    80001ea6:	fcc42783          	lw	a5,-52(s0)
    80001eaa:	cf8d                	beqz	a5,80001ee4 <sys_sleep+0x6e>
    80001eac:	f426                	sd	s1,40(sp)
    80001eae:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001eb0:	0000e997          	auipc	s3,0xe
    80001eb4:	45098993          	addi	s3,s3,1104 # 80010300 <tickslock>
    80001eb8:	00008497          	auipc	s1,0x8
    80001ebc:	5e048493          	addi	s1,s1,1504 # 8000a498 <ticks>
    if(killed(myproc())){
    80001ec0:	f99fe0ef          	jal	80000e58 <myproc>
    80001ec4:	f9aff0ef          	jal	8000165e <killed>
    80001ec8:	ed0d                	bnez	a0,80001f02 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001eca:	85ce                	mv	a1,s3
    80001ecc:	8526                	mv	a0,s1
    80001ece:	d58ff0ef          	jal	80001426 <sleep>
  while(ticks - ticks0 < n){
    80001ed2:	409c                	lw	a5,0(s1)
    80001ed4:	412787bb          	subw	a5,a5,s2
    80001ed8:	fcc42703          	lw	a4,-52(s0)
    80001edc:	fee7e2e3          	bltu	a5,a4,80001ec0 <sys_sleep+0x4a>
    80001ee0:	74a2                	ld	s1,40(sp)
    80001ee2:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ee4:	0000e517          	auipc	a0,0xe
    80001ee8:	41c50513          	addi	a0,a0,1052 # 80010300 <tickslock>
    80001eec:	2ed030ef          	jal	800059d8 <release>
  return 0;
    80001ef0:	4501                	li	a0,0
}
    80001ef2:	70e2                	ld	ra,56(sp)
    80001ef4:	7442                	ld	s0,48(sp)
    80001ef6:	7902                	ld	s2,32(sp)
    80001ef8:	6121                	addi	sp,sp,64
    80001efa:	8082                	ret
    n = 0;
    80001efc:	fc042623          	sw	zero,-52(s0)
    80001f00:	bf49                	j	80001e92 <sys_sleep+0x1c>
      release(&tickslock);
    80001f02:	0000e517          	auipc	a0,0xe
    80001f06:	3fe50513          	addi	a0,a0,1022 # 80010300 <tickslock>
    80001f0a:	2cf030ef          	jal	800059d8 <release>
      return -1;
    80001f0e:	557d                	li	a0,-1
    80001f10:	74a2                	ld	s1,40(sp)
    80001f12:	69e2                	ld	s3,24(sp)
    80001f14:	bff9                	j	80001ef2 <sys_sleep+0x7c>

0000000080001f16 <sys_pgpte>:


int
sys_pgpte(void)
{
    80001f16:	7179                	addi	sp,sp,-48
    80001f18:	f406                	sd	ra,40(sp)
    80001f1a:	f022                	sd	s0,32(sp)
    80001f1c:	ec26                	sd	s1,24(sp)
    80001f1e:	1800                	addi	s0,sp,48
  uint64 va;
  struct proc *p;  

  p = myproc();
    80001f20:	f39fe0ef          	jal	80000e58 <myproc>
    80001f24:	84aa                	mv	s1,a0
  argaddr(0, &va);
    80001f26:	fd840593          	addi	a1,s0,-40
    80001f2a:	4501                	li	a0,0
    80001f2c:	dfbff0ef          	jal	80001d26 <argaddr>
  pte_t *pte = pgpte(p->pagetable, va);
    80001f30:	fd843583          	ld	a1,-40(s0)
    80001f34:	68a8                	ld	a0,80(s1)
    80001f36:	d8ffe0ef          	jal	80000cc4 <pgpte>
    80001f3a:	87aa                	mv	a5,a0
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
    80001f3c:	4501                	li	a0,0
  if(pte != 0) {
    80001f3e:	c391                	beqz	a5,80001f42 <sys_pgpte+0x2c>
      return (uint64) *pte;
    80001f40:	4388                	lw	a0,0(a5)
}
    80001f42:	70a2                	ld	ra,40(sp)
    80001f44:	7402                	ld	s0,32(sp)
    80001f46:	64e2                	ld	s1,24(sp)
    80001f48:	6145                	addi	sp,sp,48
    80001f4a:	8082                	ret

0000000080001f4c <sys_kpgtbl>:

int
sys_kpgtbl(void)
{
    80001f4c:	1141                	addi	sp,sp,-16
    80001f4e:	e406                	sd	ra,8(sp)
    80001f50:	e022                	sd	s0,0(sp)
    80001f52:	0800                	addi	s0,sp,16
  struct proc *p;  

  p = myproc();
    80001f54:	f05fe0ef          	jal	80000e58 <myproc>
  vmprint(p->pagetable);
    80001f58:	6928                	ld	a0,80(a0)
    80001f5a:	d3ffe0ef          	jal	80000c98 <vmprint>
  return 0;
}
    80001f5e:	4501                	li	a0,0
    80001f60:	60a2                	ld	ra,8(sp)
    80001f62:	6402                	ld	s0,0(sp)
    80001f64:	0141                	addi	sp,sp,16
    80001f66:	8082                	ret

0000000080001f68 <sys_kill>:


uint64
sys_kill(void)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f70:	fec40593          	addi	a1,s0,-20
    80001f74:	4501                	li	a0,0
    80001f76:	d95ff0ef          	jal	80001d0a <argint>
  return kill(pid);
    80001f7a:	fec42503          	lw	a0,-20(s0)
    80001f7e:	e56ff0ef          	jal	800015d4 <kill>
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret

0000000080001f8a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f94:	0000e517          	auipc	a0,0xe
    80001f98:	36c50513          	addi	a0,a0,876 # 80010300 <tickslock>
    80001f9c:	1a9030ef          	jal	80005944 <acquire>
  xticks = ticks;
    80001fa0:	00008497          	auipc	s1,0x8
    80001fa4:	4f84a483          	lw	s1,1272(s1) # 8000a498 <ticks>
  release(&tickslock);
    80001fa8:	0000e517          	auipc	a0,0xe
    80001fac:	35850513          	addi	a0,a0,856 # 80010300 <tickslock>
    80001fb0:	229030ef          	jal	800059d8 <release>
  return xticks;
}
    80001fb4:	02049513          	slli	a0,s1,0x20
    80001fb8:	9101                	srli	a0,a0,0x20
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6105                	addi	sp,sp,32
    80001fc2:	8082                	ret

0000000080001fc4 <sys_vmprint>:

uint64 
sys_vmprint(void) {
    80001fc4:	1101                	addi	sp,sp,-32
    80001fc6:	ec06                	sd	ra,24(sp)
    80001fc8:	e822                	sd	s0,16(sp)
    80001fca:	1000                	addi	s0,sp,32
    uint64 pgtbl_addr;
    argaddr(0, &pgtbl_addr);  // Get argument from user space
    80001fcc:	fe840593          	addi	a1,s0,-24
    80001fd0:	4501                	li	a0,0
    80001fd2:	d55ff0ef          	jal	80001d26 <argaddr>
    vmprint((pagetable_t)pgtbl_addr);  // Call function in vm.c
    80001fd6:	fe843503          	ld	a0,-24(s0)
    80001fda:	cbffe0ef          	jal	80000c98 <vmprint>
    return 0;
}
    80001fde:	4501                	li	a0,0
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret

0000000080001fe8 <sys_pgaccess>:

uint64 sys_pgaccess(void) {
    80001fe8:	715d                	addi	sp,sp,-80
    80001fea:	e486                	sd	ra,72(sp)
    80001fec:	e0a2                	sd	s0,64(sp)
    80001fee:	f84a                	sd	s2,48(sp)
    80001ff0:	0880                	addi	s0,sp,80
  uint64 start_va, mask_user;
  uint64 numpages;

  argaddr(0, &start_va);
    80001ff2:	fc840593          	addi	a1,s0,-56
    80001ff6:	4501                	li	a0,0
    80001ff8:	d2fff0ef          	jal	80001d26 <argaddr>
  argaddr(1, &numpages);
    80001ffc:	fb840593          	addi	a1,s0,-72
    80002000:	4505                	li	a0,1
    80002002:	d25ff0ef          	jal	80001d26 <argaddr>
  argaddr(2, &mask_user);
    80002006:	fc040593          	addi	a1,s0,-64
    8000200a:	4509                	li	a0,2
    8000200c:	d1bff0ef          	jal	80001d26 <argaddr>
  
  // Parse system call arguments.
  if (start_va < 0 || numpages < 0 || mask_user < 0)
    return -1;

  struct proc *p = myproc();
    80002010:	e49fe0ef          	jal	80000e58 <myproc>
    80002014:	892a                	mv	s2,a0
  uint64 accessed_mask = 0; // Bitmask that will be returned.
    80002016:	fa043823          	sd	zero,-80(s0)

  // For each page in the range.
  for (int i = 0; i < numpages; i++) {
    8000201a:	fb843783          	ld	a5,-72(s0)
    8000201e:	cba1                	beqz	a5,8000206e <sys_pgaccess+0x86>
    80002020:	fc26                	sd	s1,56(sp)
    80002022:	f44e                	sd	s3,40(sp)
    80002024:	4481                	li	s1,0
          // If there's no mapping, leave the bit 0.
          continue;
      }
      // If the access bit (PTE_A) is set, mark it in our mask.
      if(*pte & PTE_A) {
          accessed_mask |= (1ULL << i);
    80002026:	4985                	li	s3,1
    80002028:	a031                	j	80002034 <sys_pgaccess+0x4c>
  for (int i = 0; i < numpages; i++) {
    8000202a:	0485                	addi	s1,s1,1
    8000202c:	fb843783          	ld	a5,-72(s0)
    80002030:	02f4fd63          	bgeu	s1,a5,8000206a <sys_pgaccess+0x82>
      uint64 va = start_va + i * PGSIZE; // PGSIZE is defined in memlayout.h
    80002034:	00c49593          	slli	a1,s1,0xc
      pte_t *pte = walk(p->pagetable, va, 0);
    80002038:	4601                	li	a2,0
    8000203a:	fc843783          	ld	a5,-56(s0)
    8000203e:	95be                	add	a1,a1,a5
    80002040:	05093503          	ld	a0,80(s2)
    80002044:	b9efe0ef          	jal	800003e2 <walk>
      if(pte == 0) {
    80002048:	d16d                	beqz	a0,8000202a <sys_pgaccess+0x42>
      if(*pte & PTE_A) {
    8000204a:	611c                	ld	a5,0(a0)
    8000204c:	0407f793          	andi	a5,a5,64
    80002050:	dfe9                	beqz	a5,8000202a <sys_pgaccess+0x42>
          accessed_mask |= (1ULL << i);
    80002052:	00999733          	sll	a4,s3,s1
    80002056:	fb043783          	ld	a5,-80(s0)
    8000205a:	8fd9                	or	a5,a5,a4
    8000205c:	faf43823          	sd	a5,-80(s0)
          // Clear the access bit for future calls.
          *pte &= ~PTE_A;
    80002060:	611c                	ld	a5,0(a0)
    80002062:	fbf7f793          	andi	a5,a5,-65
    80002066:	e11c                	sd	a5,0(a0)
    80002068:	b7c9                	j	8000202a <sys_pgaccess+0x42>
    8000206a:	74e2                	ld	s1,56(sp)
    8000206c:	79a2                	ld	s3,40(sp)
      }
  }
  // Copy the result bitmask to the user-provided address.
  if(copyout(p->pagetable, mask_user, (char *)&accessed_mask, sizeof(accessed_mask)) < 0) {
    8000206e:	46a1                	li	a3,8
    80002070:	fb040613          	addi	a2,s0,-80
    80002074:	fc043583          	ld	a1,-64(s0)
    80002078:	05093503          	ld	a0,80(s2)
    8000207c:	9a3fe0ef          	jal	80000a1e <copyout>
      return -1;
  }
  return 0;
}
    80002080:	957d                	srai	a0,a0,0x3f
    80002082:	60a6                	ld	ra,72(sp)
    80002084:	6406                	ld	s0,64(sp)
    80002086:	7942                	ld	s2,48(sp)
    80002088:	6161                	addi	sp,sp,80
    8000208a:	8082                	ret

000000008000208c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000208c:	7179                	addi	sp,sp,-48
    8000208e:	f406                	sd	ra,40(sp)
    80002090:	f022                	sd	s0,32(sp)
    80002092:	ec26                	sd	s1,24(sp)
    80002094:	e84a                	sd	s2,16(sp)
    80002096:	e44e                	sd	s3,8(sp)
    80002098:	e052                	sd	s4,0(sp)
    8000209a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000209c:	00005597          	auipc	a1,0x5
    800020a0:	37458593          	addi	a1,a1,884 # 80007410 <etext+0x410>
    800020a4:	0000e517          	auipc	a0,0xe
    800020a8:	27450513          	addi	a0,a0,628 # 80010318 <bcache>
    800020ac:	015030ef          	jal	800058c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800020b0:	00016797          	auipc	a5,0x16
    800020b4:	26878793          	addi	a5,a5,616 # 80018318 <bcache+0x8000>
    800020b8:	00016717          	auipc	a4,0x16
    800020bc:	4c870713          	addi	a4,a4,1224 # 80018580 <bcache+0x8268>
    800020c0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800020c4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020c8:	0000e497          	auipc	s1,0xe
    800020cc:	26848493          	addi	s1,s1,616 # 80010330 <bcache+0x18>
    b->next = bcache.head.next;
    800020d0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020d2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020d4:	00005a17          	auipc	s4,0x5
    800020d8:	344a0a13          	addi	s4,s4,836 # 80007418 <etext+0x418>
    b->next = bcache.head.next;
    800020dc:	2b893783          	ld	a5,696(s2)
    800020e0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020e2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020e6:	85d2                	mv	a1,s4
    800020e8:	01048513          	addi	a0,s1,16
    800020ec:	244010ef          	jal	80003330 <initsleeplock>
    bcache.head.next->prev = b;
    800020f0:	2b893783          	ld	a5,696(s2)
    800020f4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020f6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020fa:	45848493          	addi	s1,s1,1112
    800020fe:	fd349fe3          	bne	s1,s3,800020dc <binit+0x50>
  }
}
    80002102:	70a2                	ld	ra,40(sp)
    80002104:	7402                	ld	s0,32(sp)
    80002106:	64e2                	ld	s1,24(sp)
    80002108:	6942                	ld	s2,16(sp)
    8000210a:	69a2                	ld	s3,8(sp)
    8000210c:	6a02                	ld	s4,0(sp)
    8000210e:	6145                	addi	sp,sp,48
    80002110:	8082                	ret

0000000080002112 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002112:	7179                	addi	sp,sp,-48
    80002114:	f406                	sd	ra,40(sp)
    80002116:	f022                	sd	s0,32(sp)
    80002118:	ec26                	sd	s1,24(sp)
    8000211a:	e84a                	sd	s2,16(sp)
    8000211c:	e44e                	sd	s3,8(sp)
    8000211e:	1800                	addi	s0,sp,48
    80002120:	892a                	mv	s2,a0
    80002122:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002124:	0000e517          	auipc	a0,0xe
    80002128:	1f450513          	addi	a0,a0,500 # 80010318 <bcache>
    8000212c:	019030ef          	jal	80005944 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002130:	00016497          	auipc	s1,0x16
    80002134:	4a04b483          	ld	s1,1184(s1) # 800185d0 <bcache+0x82b8>
    80002138:	00016797          	auipc	a5,0x16
    8000213c:	44878793          	addi	a5,a5,1096 # 80018580 <bcache+0x8268>
    80002140:	02f48b63          	beq	s1,a5,80002176 <bread+0x64>
    80002144:	873e                	mv	a4,a5
    80002146:	a021                	j	8000214e <bread+0x3c>
    80002148:	68a4                	ld	s1,80(s1)
    8000214a:	02e48663          	beq	s1,a4,80002176 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000214e:	449c                	lw	a5,8(s1)
    80002150:	ff279ce3          	bne	a5,s2,80002148 <bread+0x36>
    80002154:	44dc                	lw	a5,12(s1)
    80002156:	ff3799e3          	bne	a5,s3,80002148 <bread+0x36>
      b->refcnt++;
    8000215a:	40bc                	lw	a5,64(s1)
    8000215c:	2785                	addiw	a5,a5,1
    8000215e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002160:	0000e517          	auipc	a0,0xe
    80002164:	1b850513          	addi	a0,a0,440 # 80010318 <bcache>
    80002168:	071030ef          	jal	800059d8 <release>
      acquiresleep(&b->lock);
    8000216c:	01048513          	addi	a0,s1,16
    80002170:	1f6010ef          	jal	80003366 <acquiresleep>
      return b;
    80002174:	a889                	j	800021c6 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002176:	00016497          	auipc	s1,0x16
    8000217a:	4524b483          	ld	s1,1106(s1) # 800185c8 <bcache+0x82b0>
    8000217e:	00016797          	auipc	a5,0x16
    80002182:	40278793          	addi	a5,a5,1026 # 80018580 <bcache+0x8268>
    80002186:	00f48863          	beq	s1,a5,80002196 <bread+0x84>
    8000218a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000218c:	40bc                	lw	a5,64(s1)
    8000218e:	cb91                	beqz	a5,800021a2 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002190:	64a4                	ld	s1,72(s1)
    80002192:	fee49de3          	bne	s1,a4,8000218c <bread+0x7a>
  panic("bget: no buffers");
    80002196:	00005517          	auipc	a0,0x5
    8000219a:	28a50513          	addi	a0,a0,650 # 80007420 <etext+0x420>
    8000219e:	478030ef          	jal	80005616 <panic>
      b->dev = dev;
    800021a2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800021a6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800021aa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800021ae:	4785                	li	a5,1
    800021b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800021b2:	0000e517          	auipc	a0,0xe
    800021b6:	16650513          	addi	a0,a0,358 # 80010318 <bcache>
    800021ba:	01f030ef          	jal	800059d8 <release>
      acquiresleep(&b->lock);
    800021be:	01048513          	addi	a0,s1,16
    800021c2:	1a4010ef          	jal	80003366 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800021c6:	409c                	lw	a5,0(s1)
    800021c8:	cb89                	beqz	a5,800021da <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021ca:	8526                	mv	a0,s1
    800021cc:	70a2                	ld	ra,40(sp)
    800021ce:	7402                	ld	s0,32(sp)
    800021d0:	64e2                	ld	s1,24(sp)
    800021d2:	6942                	ld	s2,16(sp)
    800021d4:	69a2                	ld	s3,8(sp)
    800021d6:	6145                	addi	sp,sp,48
    800021d8:	8082                	ret
    virtio_disk_rw(b, 0);
    800021da:	4581                	li	a1,0
    800021dc:	8526                	mv	a0,s1
    800021de:	203020ef          	jal	80004be0 <virtio_disk_rw>
    b->valid = 1;
    800021e2:	4785                	li	a5,1
    800021e4:	c09c                	sw	a5,0(s1)
  return b;
    800021e6:	b7d5                	j	800021ca <bread+0xb8>

00000000800021e8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	e426                	sd	s1,8(sp)
    800021f0:	1000                	addi	s0,sp,32
    800021f2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021f4:	0541                	addi	a0,a0,16
    800021f6:	1ee010ef          	jal	800033e4 <holdingsleep>
    800021fa:	c911                	beqz	a0,8000220e <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021fc:	4585                	li	a1,1
    800021fe:	8526                	mv	a0,s1
    80002200:	1e1020ef          	jal	80004be0 <virtio_disk_rw>
}
    80002204:	60e2                	ld	ra,24(sp)
    80002206:	6442                	ld	s0,16(sp)
    80002208:	64a2                	ld	s1,8(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret
    panic("bwrite");
    8000220e:	00005517          	auipc	a0,0x5
    80002212:	22a50513          	addi	a0,a0,554 # 80007438 <etext+0x438>
    80002216:	400030ef          	jal	80005616 <panic>

000000008000221a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000221a:	1101                	addi	sp,sp,-32
    8000221c:	ec06                	sd	ra,24(sp)
    8000221e:	e822                	sd	s0,16(sp)
    80002220:	e426                	sd	s1,8(sp)
    80002222:	e04a                	sd	s2,0(sp)
    80002224:	1000                	addi	s0,sp,32
    80002226:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002228:	01050913          	addi	s2,a0,16
    8000222c:	854a                	mv	a0,s2
    8000222e:	1b6010ef          	jal	800033e4 <holdingsleep>
    80002232:	c125                	beqz	a0,80002292 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002234:	854a                	mv	a0,s2
    80002236:	176010ef          	jal	800033ac <releasesleep>

  acquire(&bcache.lock);
    8000223a:	0000e517          	auipc	a0,0xe
    8000223e:	0de50513          	addi	a0,a0,222 # 80010318 <bcache>
    80002242:	702030ef          	jal	80005944 <acquire>
  b->refcnt--;
    80002246:	40bc                	lw	a5,64(s1)
    80002248:	37fd                	addiw	a5,a5,-1
    8000224a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000224c:	e79d                	bnez	a5,8000227a <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000224e:	68b8                	ld	a4,80(s1)
    80002250:	64bc                	ld	a5,72(s1)
    80002252:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002254:	68b8                	ld	a4,80(s1)
    80002256:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002258:	00016797          	auipc	a5,0x16
    8000225c:	0c078793          	addi	a5,a5,192 # 80018318 <bcache+0x8000>
    80002260:	2b87b703          	ld	a4,696(a5)
    80002264:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002266:	00016717          	auipc	a4,0x16
    8000226a:	31a70713          	addi	a4,a4,794 # 80018580 <bcache+0x8268>
    8000226e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002270:	2b87b703          	ld	a4,696(a5)
    80002274:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002276:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000227a:	0000e517          	auipc	a0,0xe
    8000227e:	09e50513          	addi	a0,a0,158 # 80010318 <bcache>
    80002282:	756030ef          	jal	800059d8 <release>
}
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	64a2                	ld	s1,8(sp)
    8000228c:	6902                	ld	s2,0(sp)
    8000228e:	6105                	addi	sp,sp,32
    80002290:	8082                	ret
    panic("brelse");
    80002292:	00005517          	auipc	a0,0x5
    80002296:	1ae50513          	addi	a0,a0,430 # 80007440 <etext+0x440>
    8000229a:	37c030ef          	jal	80005616 <panic>

000000008000229e <bpin>:

void
bpin(struct buf *b) {
    8000229e:	1101                	addi	sp,sp,-32
    800022a0:	ec06                	sd	ra,24(sp)
    800022a2:	e822                	sd	s0,16(sp)
    800022a4:	e426                	sd	s1,8(sp)
    800022a6:	1000                	addi	s0,sp,32
    800022a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022aa:	0000e517          	auipc	a0,0xe
    800022ae:	06e50513          	addi	a0,a0,110 # 80010318 <bcache>
    800022b2:	692030ef          	jal	80005944 <acquire>
  b->refcnt++;
    800022b6:	40bc                	lw	a5,64(s1)
    800022b8:	2785                	addiw	a5,a5,1
    800022ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022bc:	0000e517          	auipc	a0,0xe
    800022c0:	05c50513          	addi	a0,a0,92 # 80010318 <bcache>
    800022c4:	714030ef          	jal	800059d8 <release>
}
    800022c8:	60e2                	ld	ra,24(sp)
    800022ca:	6442                	ld	s0,16(sp)
    800022cc:	64a2                	ld	s1,8(sp)
    800022ce:	6105                	addi	sp,sp,32
    800022d0:	8082                	ret

00000000800022d2 <bunpin>:

void
bunpin(struct buf *b) {
    800022d2:	1101                	addi	sp,sp,-32
    800022d4:	ec06                	sd	ra,24(sp)
    800022d6:	e822                	sd	s0,16(sp)
    800022d8:	e426                	sd	s1,8(sp)
    800022da:	1000                	addi	s0,sp,32
    800022dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022de:	0000e517          	auipc	a0,0xe
    800022e2:	03a50513          	addi	a0,a0,58 # 80010318 <bcache>
    800022e6:	65e030ef          	jal	80005944 <acquire>
  b->refcnt--;
    800022ea:	40bc                	lw	a5,64(s1)
    800022ec:	37fd                	addiw	a5,a5,-1
    800022ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022f0:	0000e517          	auipc	a0,0xe
    800022f4:	02850513          	addi	a0,a0,40 # 80010318 <bcache>
    800022f8:	6e0030ef          	jal	800059d8 <release>
}
    800022fc:	60e2                	ld	ra,24(sp)
    800022fe:	6442                	ld	s0,16(sp)
    80002300:	64a2                	ld	s1,8(sp)
    80002302:	6105                	addi	sp,sp,32
    80002304:	8082                	ret

0000000080002306 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	e426                	sd	s1,8(sp)
    8000230e:	e04a                	sd	s2,0(sp)
    80002310:	1000                	addi	s0,sp,32
    80002312:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002314:	00d5d79b          	srliw	a5,a1,0xd
    80002318:	00016597          	auipc	a1,0x16
    8000231c:	6dc5a583          	lw	a1,1756(a1) # 800189f4 <sb+0x1c>
    80002320:	9dbd                	addw	a1,a1,a5
    80002322:	df1ff0ef          	jal	80002112 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002326:	0074f713          	andi	a4,s1,7
    8000232a:	4785                	li	a5,1
    8000232c:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002330:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002332:	90d9                	srli	s1,s1,0x36
    80002334:	00950733          	add	a4,a0,s1
    80002338:	05874703          	lbu	a4,88(a4)
    8000233c:	00e7f6b3          	and	a3,a5,a4
    80002340:	c29d                	beqz	a3,80002366 <bfree+0x60>
    80002342:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002344:	94aa                	add	s1,s1,a0
    80002346:	fff7c793          	not	a5,a5
    8000234a:	8f7d                	and	a4,a4,a5
    8000234c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002350:	711000ef          	jal	80003260 <log_write>
  brelse(bp);
    80002354:	854a                	mv	a0,s2
    80002356:	ec5ff0ef          	jal	8000221a <brelse>
}
    8000235a:	60e2                	ld	ra,24(sp)
    8000235c:	6442                	ld	s0,16(sp)
    8000235e:	64a2                	ld	s1,8(sp)
    80002360:	6902                	ld	s2,0(sp)
    80002362:	6105                	addi	sp,sp,32
    80002364:	8082                	ret
    panic("freeing free block");
    80002366:	00005517          	auipc	a0,0x5
    8000236a:	0e250513          	addi	a0,a0,226 # 80007448 <etext+0x448>
    8000236e:	2a8030ef          	jal	80005616 <panic>

0000000080002372 <balloc>:
{
    80002372:	715d                	addi	sp,sp,-80
    80002374:	e486                	sd	ra,72(sp)
    80002376:	e0a2                	sd	s0,64(sp)
    80002378:	fc26                	sd	s1,56(sp)
    8000237a:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000237c:	00016797          	auipc	a5,0x16
    80002380:	6607a783          	lw	a5,1632(a5) # 800189dc <sb+0x4>
    80002384:	0e078863          	beqz	a5,80002474 <balloc+0x102>
    80002388:	f84a                	sd	s2,48(sp)
    8000238a:	f44e                	sd	s3,40(sp)
    8000238c:	f052                	sd	s4,32(sp)
    8000238e:	ec56                	sd	s5,24(sp)
    80002390:	e85a                	sd	s6,16(sp)
    80002392:	e45e                	sd	s7,8(sp)
    80002394:	e062                	sd	s8,0(sp)
    80002396:	8baa                	mv	s7,a0
    80002398:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000239a:	00016b17          	auipc	s6,0x16
    8000239e:	63eb0b13          	addi	s6,s6,1598 # 800189d8 <sb>
      m = 1 << (bi % 8);
    800023a2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023a4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800023a6:	6c09                	lui	s8,0x2
    800023a8:	a09d                	j	8000240e <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800023aa:	97ca                	add	a5,a5,s2
    800023ac:	8e55                	or	a2,a2,a3
    800023ae:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800023b2:	854a                	mv	a0,s2
    800023b4:	6ad000ef          	jal	80003260 <log_write>
        brelse(bp);
    800023b8:	854a                	mv	a0,s2
    800023ba:	e61ff0ef          	jal	8000221a <brelse>
  bp = bread(dev, bno);
    800023be:	85a6                	mv	a1,s1
    800023c0:	855e                	mv	a0,s7
    800023c2:	d51ff0ef          	jal	80002112 <bread>
    800023c6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800023c8:	40000613          	li	a2,1024
    800023cc:	4581                	li	a1,0
    800023ce:	05850513          	addi	a0,a0,88
    800023d2:	d7dfd0ef          	jal	8000014e <memset>
  log_write(bp);
    800023d6:	854a                	mv	a0,s2
    800023d8:	689000ef          	jal	80003260 <log_write>
  brelse(bp);
    800023dc:	854a                	mv	a0,s2
    800023de:	e3dff0ef          	jal	8000221a <brelse>
}
    800023e2:	7942                	ld	s2,48(sp)
    800023e4:	79a2                	ld	s3,40(sp)
    800023e6:	7a02                	ld	s4,32(sp)
    800023e8:	6ae2                	ld	s5,24(sp)
    800023ea:	6b42                	ld	s6,16(sp)
    800023ec:	6ba2                	ld	s7,8(sp)
    800023ee:	6c02                	ld	s8,0(sp)
}
    800023f0:	8526                	mv	a0,s1
    800023f2:	60a6                	ld	ra,72(sp)
    800023f4:	6406                	ld	s0,64(sp)
    800023f6:	74e2                	ld	s1,56(sp)
    800023f8:	6161                	addi	sp,sp,80
    800023fa:	8082                	ret
    brelse(bp);
    800023fc:	854a                	mv	a0,s2
    800023fe:	e1dff0ef          	jal	8000221a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002402:	015c0abb          	addw	s5,s8,s5
    80002406:	004b2783          	lw	a5,4(s6)
    8000240a:	04fafe63          	bgeu	s5,a5,80002466 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    8000240e:	41fad79b          	sraiw	a5,s5,0x1f
    80002412:	0137d79b          	srliw	a5,a5,0x13
    80002416:	015787bb          	addw	a5,a5,s5
    8000241a:	40d7d79b          	sraiw	a5,a5,0xd
    8000241e:	01cb2583          	lw	a1,28(s6)
    80002422:	9dbd                	addw	a1,a1,a5
    80002424:	855e                	mv	a0,s7
    80002426:	cedff0ef          	jal	80002112 <bread>
    8000242a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000242c:	004b2503          	lw	a0,4(s6)
    80002430:	84d6                	mv	s1,s5
    80002432:	4701                	li	a4,0
    80002434:	fca4f4e3          	bgeu	s1,a0,800023fc <balloc+0x8a>
      m = 1 << (bi % 8);
    80002438:	00777693          	andi	a3,a4,7
    8000243c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002440:	41f7579b          	sraiw	a5,a4,0x1f
    80002444:	01d7d79b          	srliw	a5,a5,0x1d
    80002448:	9fb9                	addw	a5,a5,a4
    8000244a:	4037d79b          	sraiw	a5,a5,0x3
    8000244e:	00f90633          	add	a2,s2,a5
    80002452:	05864603          	lbu	a2,88(a2)
    80002456:	00c6f5b3          	and	a1,a3,a2
    8000245a:	d9a1                	beqz	a1,800023aa <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000245c:	2705                	addiw	a4,a4,1
    8000245e:	2485                	addiw	s1,s1,1
    80002460:	fd471ae3          	bne	a4,s4,80002434 <balloc+0xc2>
    80002464:	bf61                	j	800023fc <balloc+0x8a>
    80002466:	7942                	ld	s2,48(sp)
    80002468:	79a2                	ld	s3,40(sp)
    8000246a:	7a02                	ld	s4,32(sp)
    8000246c:	6ae2                	ld	s5,24(sp)
    8000246e:	6b42                	ld	s6,16(sp)
    80002470:	6ba2                	ld	s7,8(sp)
    80002472:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002474:	00005517          	auipc	a0,0x5
    80002478:	fec50513          	addi	a0,a0,-20 # 80007460 <etext+0x460>
    8000247c:	6cb020ef          	jal	80005346 <printf>
  return 0;
    80002480:	4481                	li	s1,0
    80002482:	b7bd                	j	800023f0 <balloc+0x7e>

0000000080002484 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002484:	7179                	addi	sp,sp,-48
    80002486:	f406                	sd	ra,40(sp)
    80002488:	f022                	sd	s0,32(sp)
    8000248a:	ec26                	sd	s1,24(sp)
    8000248c:	e84a                	sd	s2,16(sp)
    8000248e:	e44e                	sd	s3,8(sp)
    80002490:	1800                	addi	s0,sp,48
    80002492:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002494:	47ad                	li	a5,11
    80002496:	02b7e363          	bltu	a5,a1,800024bc <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000249a:	02059793          	slli	a5,a1,0x20
    8000249e:	01e7d593          	srli	a1,a5,0x1e
    800024a2:	00b504b3          	add	s1,a0,a1
    800024a6:	0504a903          	lw	s2,80(s1)
    800024aa:	06091363          	bnez	s2,80002510 <bmap+0x8c>
      addr = balloc(ip->dev);
    800024ae:	4108                	lw	a0,0(a0)
    800024b0:	ec3ff0ef          	jal	80002372 <balloc>
    800024b4:	892a                	mv	s2,a0
      if(addr == 0)
    800024b6:	cd29                	beqz	a0,80002510 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800024b8:	c8a8                	sw	a0,80(s1)
    800024ba:	a899                	j	80002510 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800024bc:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800024c0:	0ff00793          	li	a5,255
    800024c4:	0697e963          	bltu	a5,s1,80002536 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800024c8:	08052903          	lw	s2,128(a0)
    800024cc:	00091b63          	bnez	s2,800024e2 <bmap+0x5e>
      addr = balloc(ip->dev);
    800024d0:	4108                	lw	a0,0(a0)
    800024d2:	ea1ff0ef          	jal	80002372 <balloc>
    800024d6:	892a                	mv	s2,a0
      if(addr == 0)
    800024d8:	cd05                	beqz	a0,80002510 <bmap+0x8c>
    800024da:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024dc:	08a9a023          	sw	a0,128(s3)
    800024e0:	a011                	j	800024e4 <bmap+0x60>
    800024e2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800024e4:	85ca                	mv	a1,s2
    800024e6:	0009a503          	lw	a0,0(s3)
    800024ea:	c29ff0ef          	jal	80002112 <bread>
    800024ee:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024f0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024f4:	02049713          	slli	a4,s1,0x20
    800024f8:	01e75593          	srli	a1,a4,0x1e
    800024fc:	00b784b3          	add	s1,a5,a1
    80002500:	0004a903          	lw	s2,0(s1)
    80002504:	00090e63          	beqz	s2,80002520 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002508:	8552                	mv	a0,s4
    8000250a:	d11ff0ef          	jal	8000221a <brelse>
    return addr;
    8000250e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002510:	854a                	mv	a0,s2
    80002512:	70a2                	ld	ra,40(sp)
    80002514:	7402                	ld	s0,32(sp)
    80002516:	64e2                	ld	s1,24(sp)
    80002518:	6942                	ld	s2,16(sp)
    8000251a:	69a2                	ld	s3,8(sp)
    8000251c:	6145                	addi	sp,sp,48
    8000251e:	8082                	ret
      addr = balloc(ip->dev);
    80002520:	0009a503          	lw	a0,0(s3)
    80002524:	e4fff0ef          	jal	80002372 <balloc>
    80002528:	892a                	mv	s2,a0
      if(addr){
    8000252a:	dd79                	beqz	a0,80002508 <bmap+0x84>
        a[bn] = addr;
    8000252c:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000252e:	8552                	mv	a0,s4
    80002530:	531000ef          	jal	80003260 <log_write>
    80002534:	bfd1                	j	80002508 <bmap+0x84>
    80002536:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002538:	00005517          	auipc	a0,0x5
    8000253c:	f4050513          	addi	a0,a0,-192 # 80007478 <etext+0x478>
    80002540:	0d6030ef          	jal	80005616 <panic>

0000000080002544 <iget>:
{
    80002544:	7179                	addi	sp,sp,-48
    80002546:	f406                	sd	ra,40(sp)
    80002548:	f022                	sd	s0,32(sp)
    8000254a:	ec26                	sd	s1,24(sp)
    8000254c:	e84a                	sd	s2,16(sp)
    8000254e:	e44e                	sd	s3,8(sp)
    80002550:	e052                	sd	s4,0(sp)
    80002552:	1800                	addi	s0,sp,48
    80002554:	89aa                	mv	s3,a0
    80002556:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002558:	00016517          	auipc	a0,0x16
    8000255c:	4a050513          	addi	a0,a0,1184 # 800189f8 <itable>
    80002560:	3e4030ef          	jal	80005944 <acquire>
  empty = 0;
    80002564:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002566:	00016497          	auipc	s1,0x16
    8000256a:	4aa48493          	addi	s1,s1,1194 # 80018a10 <itable+0x18>
    8000256e:	00018697          	auipc	a3,0x18
    80002572:	f3268693          	addi	a3,a3,-206 # 8001a4a0 <log>
    80002576:	a039                	j	80002584 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002578:	02090963          	beqz	s2,800025aa <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000257c:	08848493          	addi	s1,s1,136
    80002580:	02d48863          	beq	s1,a3,800025b0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002584:	449c                	lw	a5,8(s1)
    80002586:	fef059e3          	blez	a5,80002578 <iget+0x34>
    8000258a:	4098                	lw	a4,0(s1)
    8000258c:	ff3716e3          	bne	a4,s3,80002578 <iget+0x34>
    80002590:	40d8                	lw	a4,4(s1)
    80002592:	ff4713e3          	bne	a4,s4,80002578 <iget+0x34>
      ip->ref++;
    80002596:	2785                	addiw	a5,a5,1
    80002598:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000259a:	00016517          	auipc	a0,0x16
    8000259e:	45e50513          	addi	a0,a0,1118 # 800189f8 <itable>
    800025a2:	436030ef          	jal	800059d8 <release>
      return ip;
    800025a6:	8926                	mv	s2,s1
    800025a8:	a02d                	j	800025d2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800025aa:	fbe9                	bnez	a5,8000257c <iget+0x38>
      empty = ip;
    800025ac:	8926                	mv	s2,s1
    800025ae:	b7f9                	j	8000257c <iget+0x38>
  if(empty == 0)
    800025b0:	02090a63          	beqz	s2,800025e4 <iget+0xa0>
  ip->dev = dev;
    800025b4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800025b8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800025bc:	4785                	li	a5,1
    800025be:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800025c2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800025c6:	00016517          	auipc	a0,0x16
    800025ca:	43250513          	addi	a0,a0,1074 # 800189f8 <itable>
    800025ce:	40a030ef          	jal	800059d8 <release>
}
    800025d2:	854a                	mv	a0,s2
    800025d4:	70a2                	ld	ra,40(sp)
    800025d6:	7402                	ld	s0,32(sp)
    800025d8:	64e2                	ld	s1,24(sp)
    800025da:	6942                	ld	s2,16(sp)
    800025dc:	69a2                	ld	s3,8(sp)
    800025de:	6a02                	ld	s4,0(sp)
    800025e0:	6145                	addi	sp,sp,48
    800025e2:	8082                	ret
    panic("iget: no inodes");
    800025e4:	00005517          	auipc	a0,0x5
    800025e8:	eac50513          	addi	a0,a0,-340 # 80007490 <etext+0x490>
    800025ec:	02a030ef          	jal	80005616 <panic>

00000000800025f0 <fsinit>:
fsinit(int dev) {
    800025f0:	7179                	addi	sp,sp,-48
    800025f2:	f406                	sd	ra,40(sp)
    800025f4:	f022                	sd	s0,32(sp)
    800025f6:	ec26                	sd	s1,24(sp)
    800025f8:	e84a                	sd	s2,16(sp)
    800025fa:	e44e                	sd	s3,8(sp)
    800025fc:	1800                	addi	s0,sp,48
    800025fe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002600:	4585                	li	a1,1
    80002602:	b11ff0ef          	jal	80002112 <bread>
    80002606:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002608:	00016997          	auipc	s3,0x16
    8000260c:	3d098993          	addi	s3,s3,976 # 800189d8 <sb>
    80002610:	02000613          	li	a2,32
    80002614:	05850593          	addi	a1,a0,88
    80002618:	854e                	mv	a0,s3
    8000261a:	b99fd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    8000261e:	8526                	mv	a0,s1
    80002620:	bfbff0ef          	jal	8000221a <brelse>
  if(sb.magic != FSMAGIC)
    80002624:	0009a703          	lw	a4,0(s3)
    80002628:	102037b7          	lui	a5,0x10203
    8000262c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002630:	02f71063          	bne	a4,a5,80002650 <fsinit+0x60>
  initlog(dev, &sb);
    80002634:	00016597          	auipc	a1,0x16
    80002638:	3a458593          	addi	a1,a1,932 # 800189d8 <sb>
    8000263c:	854a                	mv	a0,s2
    8000263e:	215000ef          	jal	80003052 <initlog>
}
    80002642:	70a2                	ld	ra,40(sp)
    80002644:	7402                	ld	s0,32(sp)
    80002646:	64e2                	ld	s1,24(sp)
    80002648:	6942                	ld	s2,16(sp)
    8000264a:	69a2                	ld	s3,8(sp)
    8000264c:	6145                	addi	sp,sp,48
    8000264e:	8082                	ret
    panic("invalid file system");
    80002650:	00005517          	auipc	a0,0x5
    80002654:	e5050513          	addi	a0,a0,-432 # 800074a0 <etext+0x4a0>
    80002658:	7bf020ef          	jal	80005616 <panic>

000000008000265c <iinit>:
{
    8000265c:	7179                	addi	sp,sp,-48
    8000265e:	f406                	sd	ra,40(sp)
    80002660:	f022                	sd	s0,32(sp)
    80002662:	ec26                	sd	s1,24(sp)
    80002664:	e84a                	sd	s2,16(sp)
    80002666:	e44e                	sd	s3,8(sp)
    80002668:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000266a:	00005597          	auipc	a1,0x5
    8000266e:	e4e58593          	addi	a1,a1,-434 # 800074b8 <etext+0x4b8>
    80002672:	00016517          	auipc	a0,0x16
    80002676:	38650513          	addi	a0,a0,902 # 800189f8 <itable>
    8000267a:	246030ef          	jal	800058c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000267e:	00016497          	auipc	s1,0x16
    80002682:	3a248493          	addi	s1,s1,930 # 80018a20 <itable+0x28>
    80002686:	00018997          	auipc	s3,0x18
    8000268a:	e2a98993          	addi	s3,s3,-470 # 8001a4b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000268e:	00005917          	auipc	s2,0x5
    80002692:	e3290913          	addi	s2,s2,-462 # 800074c0 <etext+0x4c0>
    80002696:	85ca                	mv	a1,s2
    80002698:	8526                	mv	a0,s1
    8000269a:	497000ef          	jal	80003330 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000269e:	08848493          	addi	s1,s1,136
    800026a2:	ff349ae3          	bne	s1,s3,80002696 <iinit+0x3a>
}
    800026a6:	70a2                	ld	ra,40(sp)
    800026a8:	7402                	ld	s0,32(sp)
    800026aa:	64e2                	ld	s1,24(sp)
    800026ac:	6942                	ld	s2,16(sp)
    800026ae:	69a2                	ld	s3,8(sp)
    800026b0:	6145                	addi	sp,sp,48
    800026b2:	8082                	ret

00000000800026b4 <ialloc>:
{
    800026b4:	7139                	addi	sp,sp,-64
    800026b6:	fc06                	sd	ra,56(sp)
    800026b8:	f822                	sd	s0,48(sp)
    800026ba:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800026bc:	00016717          	auipc	a4,0x16
    800026c0:	32872703          	lw	a4,808(a4) # 800189e4 <sb+0xc>
    800026c4:	4785                	li	a5,1
    800026c6:	06e7f063          	bgeu	a5,a4,80002726 <ialloc+0x72>
    800026ca:	f426                	sd	s1,40(sp)
    800026cc:	f04a                	sd	s2,32(sp)
    800026ce:	ec4e                	sd	s3,24(sp)
    800026d0:	e852                	sd	s4,16(sp)
    800026d2:	e456                	sd	s5,8(sp)
    800026d4:	e05a                	sd	s6,0(sp)
    800026d6:	8aaa                	mv	s5,a0
    800026d8:	8b2e                	mv	s6,a1
    800026da:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800026dc:	00016a17          	auipc	s4,0x16
    800026e0:	2fca0a13          	addi	s4,s4,764 # 800189d8 <sb>
    800026e4:	00495593          	srli	a1,s2,0x4
    800026e8:	018a2783          	lw	a5,24(s4)
    800026ec:	9dbd                	addw	a1,a1,a5
    800026ee:	8556                	mv	a0,s5
    800026f0:	a23ff0ef          	jal	80002112 <bread>
    800026f4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800026f6:	05850993          	addi	s3,a0,88
    800026fa:	00f97793          	andi	a5,s2,15
    800026fe:	079a                	slli	a5,a5,0x6
    80002700:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002702:	00099783          	lh	a5,0(s3)
    80002706:	cb9d                	beqz	a5,8000273c <ialloc+0x88>
    brelse(bp);
    80002708:	b13ff0ef          	jal	8000221a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000270c:	0905                	addi	s2,s2,1
    8000270e:	00ca2703          	lw	a4,12(s4)
    80002712:	0009079b          	sext.w	a5,s2
    80002716:	fce7e7e3          	bltu	a5,a4,800026e4 <ialloc+0x30>
    8000271a:	74a2                	ld	s1,40(sp)
    8000271c:	7902                	ld	s2,32(sp)
    8000271e:	69e2                	ld	s3,24(sp)
    80002720:	6a42                	ld	s4,16(sp)
    80002722:	6aa2                	ld	s5,8(sp)
    80002724:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	da250513          	addi	a0,a0,-606 # 800074c8 <etext+0x4c8>
    8000272e:	419020ef          	jal	80005346 <printf>
  return 0;
    80002732:	4501                	li	a0,0
}
    80002734:	70e2                	ld	ra,56(sp)
    80002736:	7442                	ld	s0,48(sp)
    80002738:	6121                	addi	sp,sp,64
    8000273a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000273c:	04000613          	li	a2,64
    80002740:	4581                	li	a1,0
    80002742:	854e                	mv	a0,s3
    80002744:	a0bfd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002748:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000274c:	8526                	mv	a0,s1
    8000274e:	313000ef          	jal	80003260 <log_write>
      brelse(bp);
    80002752:	8526                	mv	a0,s1
    80002754:	ac7ff0ef          	jal	8000221a <brelse>
      return iget(dev, inum);
    80002758:	0009059b          	sext.w	a1,s2
    8000275c:	8556                	mv	a0,s5
    8000275e:	de7ff0ef          	jal	80002544 <iget>
    80002762:	74a2                	ld	s1,40(sp)
    80002764:	7902                	ld	s2,32(sp)
    80002766:	69e2                	ld	s3,24(sp)
    80002768:	6a42                	ld	s4,16(sp)
    8000276a:	6aa2                	ld	s5,8(sp)
    8000276c:	6b02                	ld	s6,0(sp)
    8000276e:	b7d9                	j	80002734 <ialloc+0x80>

0000000080002770 <iupdate>:
{
    80002770:	1101                	addi	sp,sp,-32
    80002772:	ec06                	sd	ra,24(sp)
    80002774:	e822                	sd	s0,16(sp)
    80002776:	e426                	sd	s1,8(sp)
    80002778:	e04a                	sd	s2,0(sp)
    8000277a:	1000                	addi	s0,sp,32
    8000277c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000277e:	415c                	lw	a5,4(a0)
    80002780:	0047d79b          	srliw	a5,a5,0x4
    80002784:	00016597          	auipc	a1,0x16
    80002788:	26c5a583          	lw	a1,620(a1) # 800189f0 <sb+0x18>
    8000278c:	9dbd                	addw	a1,a1,a5
    8000278e:	4108                	lw	a0,0(a0)
    80002790:	983ff0ef          	jal	80002112 <bread>
    80002794:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002796:	05850793          	addi	a5,a0,88
    8000279a:	40d8                	lw	a4,4(s1)
    8000279c:	8b3d                	andi	a4,a4,15
    8000279e:	071a                	slli	a4,a4,0x6
    800027a0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800027a2:	04449703          	lh	a4,68(s1)
    800027a6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800027aa:	04649703          	lh	a4,70(s1)
    800027ae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800027b2:	04849703          	lh	a4,72(s1)
    800027b6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800027ba:	04a49703          	lh	a4,74(s1)
    800027be:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800027c2:	44f8                	lw	a4,76(s1)
    800027c4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800027c6:	03400613          	li	a2,52
    800027ca:	05048593          	addi	a1,s1,80
    800027ce:	00c78513          	addi	a0,a5,12
    800027d2:	9e1fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    800027d6:	854a                	mv	a0,s2
    800027d8:	289000ef          	jal	80003260 <log_write>
  brelse(bp);
    800027dc:	854a                	mv	a0,s2
    800027de:	a3dff0ef          	jal	8000221a <brelse>
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6902                	ld	s2,0(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret

00000000800027ee <idup>:
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027fa:	00016517          	auipc	a0,0x16
    800027fe:	1fe50513          	addi	a0,a0,510 # 800189f8 <itable>
    80002802:	142030ef          	jal	80005944 <acquire>
  ip->ref++;
    80002806:	449c                	lw	a5,8(s1)
    80002808:	2785                	addiw	a5,a5,1
    8000280a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000280c:	00016517          	auipc	a0,0x16
    80002810:	1ec50513          	addi	a0,a0,492 # 800189f8 <itable>
    80002814:	1c4030ef          	jal	800059d8 <release>
}
    80002818:	8526                	mv	a0,s1
    8000281a:	60e2                	ld	ra,24(sp)
    8000281c:	6442                	ld	s0,16(sp)
    8000281e:	64a2                	ld	s1,8(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <ilock>:
{
    80002824:	1101                	addi	sp,sp,-32
    80002826:	ec06                	sd	ra,24(sp)
    80002828:	e822                	sd	s0,16(sp)
    8000282a:	e426                	sd	s1,8(sp)
    8000282c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000282e:	cd19                	beqz	a0,8000284c <ilock+0x28>
    80002830:	84aa                	mv	s1,a0
    80002832:	451c                	lw	a5,8(a0)
    80002834:	00f05c63          	blez	a5,8000284c <ilock+0x28>
  acquiresleep(&ip->lock);
    80002838:	0541                	addi	a0,a0,16
    8000283a:	32d000ef          	jal	80003366 <acquiresleep>
  if(ip->valid == 0){
    8000283e:	40bc                	lw	a5,64(s1)
    80002840:	cf89                	beqz	a5,8000285a <ilock+0x36>
}
    80002842:	60e2                	ld	ra,24(sp)
    80002844:	6442                	ld	s0,16(sp)
    80002846:	64a2                	ld	s1,8(sp)
    80002848:	6105                	addi	sp,sp,32
    8000284a:	8082                	ret
    8000284c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000284e:	00005517          	auipc	a0,0x5
    80002852:	c9250513          	addi	a0,a0,-878 # 800074e0 <etext+0x4e0>
    80002856:	5c1020ef          	jal	80005616 <panic>
    8000285a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000285c:	40dc                	lw	a5,4(s1)
    8000285e:	0047d79b          	srliw	a5,a5,0x4
    80002862:	00016597          	auipc	a1,0x16
    80002866:	18e5a583          	lw	a1,398(a1) # 800189f0 <sb+0x18>
    8000286a:	9dbd                	addw	a1,a1,a5
    8000286c:	4088                	lw	a0,0(s1)
    8000286e:	8a5ff0ef          	jal	80002112 <bread>
    80002872:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002874:	05850593          	addi	a1,a0,88
    80002878:	40dc                	lw	a5,4(s1)
    8000287a:	8bbd                	andi	a5,a5,15
    8000287c:	079a                	slli	a5,a5,0x6
    8000287e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002880:	00059783          	lh	a5,0(a1)
    80002884:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002888:	00259783          	lh	a5,2(a1)
    8000288c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002890:	00459783          	lh	a5,4(a1)
    80002894:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002898:	00659783          	lh	a5,6(a1)
    8000289c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800028a0:	459c                	lw	a5,8(a1)
    800028a2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800028a4:	03400613          	li	a2,52
    800028a8:	05b1                	addi	a1,a1,12
    800028aa:	05048513          	addi	a0,s1,80
    800028ae:	905fd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    800028b2:	854a                	mv	a0,s2
    800028b4:	967ff0ef          	jal	8000221a <brelse>
    ip->valid = 1;
    800028b8:	4785                	li	a5,1
    800028ba:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800028bc:	04449783          	lh	a5,68(s1)
    800028c0:	c399                	beqz	a5,800028c6 <ilock+0xa2>
    800028c2:	6902                	ld	s2,0(sp)
    800028c4:	bfbd                	j	80002842 <ilock+0x1e>
      panic("ilock: no type");
    800028c6:	00005517          	auipc	a0,0x5
    800028ca:	c2250513          	addi	a0,a0,-990 # 800074e8 <etext+0x4e8>
    800028ce:	549020ef          	jal	80005616 <panic>

00000000800028d2 <iunlock>:
{
    800028d2:	1101                	addi	sp,sp,-32
    800028d4:	ec06                	sd	ra,24(sp)
    800028d6:	e822                	sd	s0,16(sp)
    800028d8:	e426                	sd	s1,8(sp)
    800028da:	e04a                	sd	s2,0(sp)
    800028dc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800028de:	c505                	beqz	a0,80002906 <iunlock+0x34>
    800028e0:	84aa                	mv	s1,a0
    800028e2:	01050913          	addi	s2,a0,16
    800028e6:	854a                	mv	a0,s2
    800028e8:	2fd000ef          	jal	800033e4 <holdingsleep>
    800028ec:	cd09                	beqz	a0,80002906 <iunlock+0x34>
    800028ee:	449c                	lw	a5,8(s1)
    800028f0:	00f05b63          	blez	a5,80002906 <iunlock+0x34>
  releasesleep(&ip->lock);
    800028f4:	854a                	mv	a0,s2
    800028f6:	2b7000ef          	jal	800033ac <releasesleep>
}
    800028fa:	60e2                	ld	ra,24(sp)
    800028fc:	6442                	ld	s0,16(sp)
    800028fe:	64a2                	ld	s1,8(sp)
    80002900:	6902                	ld	s2,0(sp)
    80002902:	6105                	addi	sp,sp,32
    80002904:	8082                	ret
    panic("iunlock");
    80002906:	00005517          	auipc	a0,0x5
    8000290a:	bf250513          	addi	a0,a0,-1038 # 800074f8 <etext+0x4f8>
    8000290e:	509020ef          	jal	80005616 <panic>

0000000080002912 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002912:	7179                	addi	sp,sp,-48
    80002914:	f406                	sd	ra,40(sp)
    80002916:	f022                	sd	s0,32(sp)
    80002918:	ec26                	sd	s1,24(sp)
    8000291a:	e84a                	sd	s2,16(sp)
    8000291c:	e44e                	sd	s3,8(sp)
    8000291e:	1800                	addi	s0,sp,48
    80002920:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002922:	05050493          	addi	s1,a0,80
    80002926:	08050913          	addi	s2,a0,128
    8000292a:	a021                	j	80002932 <itrunc+0x20>
    8000292c:	0491                	addi	s1,s1,4
    8000292e:	01248b63          	beq	s1,s2,80002944 <itrunc+0x32>
    if(ip->addrs[i]){
    80002932:	408c                	lw	a1,0(s1)
    80002934:	dde5                	beqz	a1,8000292c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002936:	0009a503          	lw	a0,0(s3)
    8000293a:	9cdff0ef          	jal	80002306 <bfree>
      ip->addrs[i] = 0;
    8000293e:	0004a023          	sw	zero,0(s1)
    80002942:	b7ed                	j	8000292c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002944:	0809a583          	lw	a1,128(s3)
    80002948:	ed89                	bnez	a1,80002962 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000294a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000294e:	854e                	mv	a0,s3
    80002950:	e21ff0ef          	jal	80002770 <iupdate>
}
    80002954:	70a2                	ld	ra,40(sp)
    80002956:	7402                	ld	s0,32(sp)
    80002958:	64e2                	ld	s1,24(sp)
    8000295a:	6942                	ld	s2,16(sp)
    8000295c:	69a2                	ld	s3,8(sp)
    8000295e:	6145                	addi	sp,sp,48
    80002960:	8082                	ret
    80002962:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002964:	0009a503          	lw	a0,0(s3)
    80002968:	faaff0ef          	jal	80002112 <bread>
    8000296c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000296e:	05850493          	addi	s1,a0,88
    80002972:	45850913          	addi	s2,a0,1112
    80002976:	a021                	j	8000297e <itrunc+0x6c>
    80002978:	0491                	addi	s1,s1,4
    8000297a:	01248963          	beq	s1,s2,8000298c <itrunc+0x7a>
      if(a[j])
    8000297e:	408c                	lw	a1,0(s1)
    80002980:	dde5                	beqz	a1,80002978 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002982:	0009a503          	lw	a0,0(s3)
    80002986:	981ff0ef          	jal	80002306 <bfree>
    8000298a:	b7fd                	j	80002978 <itrunc+0x66>
    brelse(bp);
    8000298c:	8552                	mv	a0,s4
    8000298e:	88dff0ef          	jal	8000221a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002992:	0809a583          	lw	a1,128(s3)
    80002996:	0009a503          	lw	a0,0(s3)
    8000299a:	96dff0ef          	jal	80002306 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000299e:	0809a023          	sw	zero,128(s3)
    800029a2:	6a02                	ld	s4,0(sp)
    800029a4:	b75d                	j	8000294a <itrunc+0x38>

00000000800029a6 <iput>:
{
    800029a6:	1101                	addi	sp,sp,-32
    800029a8:	ec06                	sd	ra,24(sp)
    800029aa:	e822                	sd	s0,16(sp)
    800029ac:	e426                	sd	s1,8(sp)
    800029ae:	1000                	addi	s0,sp,32
    800029b0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029b2:	00016517          	auipc	a0,0x16
    800029b6:	04650513          	addi	a0,a0,70 # 800189f8 <itable>
    800029ba:	78b020ef          	jal	80005944 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029be:	4498                	lw	a4,8(s1)
    800029c0:	4785                	li	a5,1
    800029c2:	02f70063          	beq	a4,a5,800029e2 <iput+0x3c>
  ip->ref--;
    800029c6:	449c                	lw	a5,8(s1)
    800029c8:	37fd                	addiw	a5,a5,-1
    800029ca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029cc:	00016517          	auipc	a0,0x16
    800029d0:	02c50513          	addi	a0,a0,44 # 800189f8 <itable>
    800029d4:	004030ef          	jal	800059d8 <release>
}
    800029d8:	60e2                	ld	ra,24(sp)
    800029da:	6442                	ld	s0,16(sp)
    800029dc:	64a2                	ld	s1,8(sp)
    800029de:	6105                	addi	sp,sp,32
    800029e0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029e2:	40bc                	lw	a5,64(s1)
    800029e4:	d3ed                	beqz	a5,800029c6 <iput+0x20>
    800029e6:	04a49783          	lh	a5,74(s1)
    800029ea:	fff1                	bnez	a5,800029c6 <iput+0x20>
    800029ec:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800029ee:	01048913          	addi	s2,s1,16
    800029f2:	854a                	mv	a0,s2
    800029f4:	173000ef          	jal	80003366 <acquiresleep>
    release(&itable.lock);
    800029f8:	00016517          	auipc	a0,0x16
    800029fc:	00050513          	mv	a0,a0
    80002a00:	7d9020ef          	jal	800059d8 <release>
    itrunc(ip);
    80002a04:	8526                	mv	a0,s1
    80002a06:	f0dff0ef          	jal	80002912 <itrunc>
    ip->type = 0;
    80002a0a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002a0e:	8526                	mv	a0,s1
    80002a10:	d61ff0ef          	jal	80002770 <iupdate>
    ip->valid = 0;
    80002a14:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002a18:	854a                	mv	a0,s2
    80002a1a:	193000ef          	jal	800033ac <releasesleep>
    acquire(&itable.lock);
    80002a1e:	00016517          	auipc	a0,0x16
    80002a22:	fda50513          	addi	a0,a0,-38 # 800189f8 <itable>
    80002a26:	71f020ef          	jal	80005944 <acquire>
    80002a2a:	6902                	ld	s2,0(sp)
    80002a2c:	bf69                	j	800029c6 <iput+0x20>

0000000080002a2e <iunlockput>:
{
    80002a2e:	1101                	addi	sp,sp,-32
    80002a30:	ec06                	sd	ra,24(sp)
    80002a32:	e822                	sd	s0,16(sp)
    80002a34:	e426                	sd	s1,8(sp)
    80002a36:	1000                	addi	s0,sp,32
    80002a38:	84aa                	mv	s1,a0
  iunlock(ip);
    80002a3a:	e99ff0ef          	jal	800028d2 <iunlock>
  iput(ip);
    80002a3e:	8526                	mv	a0,s1
    80002a40:	f67ff0ef          	jal	800029a6 <iput>
}
    80002a44:	60e2                	ld	ra,24(sp)
    80002a46:	6442                	ld	s0,16(sp)
    80002a48:	64a2                	ld	s1,8(sp)
    80002a4a:	6105                	addi	sp,sp,32
    80002a4c:	8082                	ret

0000000080002a4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a4e:	1141                	addi	sp,sp,-16
    80002a50:	e406                	sd	ra,8(sp)
    80002a52:	e022                	sd	s0,0(sp)
    80002a54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a56:	411c                	lw	a5,0(a0)
    80002a58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a5a:	415c                	lw	a5,4(a0)
    80002a5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a5e:	04451783          	lh	a5,68(a0)
    80002a62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a66:	04a51783          	lh	a5,74(a0)
    80002a6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a6e:	04c56783          	lwu	a5,76(a0)
    80002a72:	e99c                	sd	a5,16(a1)
}
    80002a74:	60a2                	ld	ra,8(sp)
    80002a76:	6402                	ld	s0,0(sp)
    80002a78:	0141                	addi	sp,sp,16
    80002a7a:	8082                	ret

0000000080002a7c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a7c:	457c                	lw	a5,76(a0)
    80002a7e:	0ed7e663          	bltu	a5,a3,80002b6a <readi+0xee>
{
    80002a82:	7159                	addi	sp,sp,-112
    80002a84:	f486                	sd	ra,104(sp)
    80002a86:	f0a2                	sd	s0,96(sp)
    80002a88:	eca6                	sd	s1,88(sp)
    80002a8a:	e0d2                	sd	s4,64(sp)
    80002a8c:	fc56                	sd	s5,56(sp)
    80002a8e:	f85a                	sd	s6,48(sp)
    80002a90:	f45e                	sd	s7,40(sp)
    80002a92:	1880                	addi	s0,sp,112
    80002a94:	8b2a                	mv	s6,a0
    80002a96:	8bae                	mv	s7,a1
    80002a98:	8a32                	mv	s4,a2
    80002a9a:	84b6                	mv	s1,a3
    80002a9c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a9e:	9f35                	addw	a4,a4,a3
    return 0;
    80002aa0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002aa2:	0ad76b63          	bltu	a4,a3,80002b58 <readi+0xdc>
    80002aa6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002aa8:	00e7f463          	bgeu	a5,a4,80002ab0 <readi+0x34>
    n = ip->size - off;
    80002aac:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab0:	080a8b63          	beqz	s5,80002b46 <readi+0xca>
    80002ab4:	e8ca                	sd	s2,80(sp)
    80002ab6:	f062                	sd	s8,32(sp)
    80002ab8:	ec66                	sd	s9,24(sp)
    80002aba:	e86a                	sd	s10,16(sp)
    80002abc:	e46e                	sd	s11,8(sp)
    80002abe:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ac0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ac4:	5c7d                	li	s8,-1
    80002ac6:	a80d                	j	80002af8 <readi+0x7c>
    80002ac8:	020d1d93          	slli	s11,s10,0x20
    80002acc:	020ddd93          	srli	s11,s11,0x20
    80002ad0:	05890613          	addi	a2,s2,88
    80002ad4:	86ee                	mv	a3,s11
    80002ad6:	963e                	add	a2,a2,a5
    80002ad8:	85d2                	mv	a1,s4
    80002ada:	855e                	mv	a0,s7
    80002adc:	ca1fe0ef          	jal	8000177c <either_copyout>
    80002ae0:	05850363          	beq	a0,s8,80002b26 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	f34ff0ef          	jal	8000221a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aea:	013d09bb          	addw	s3,s10,s3
    80002aee:	009d04bb          	addw	s1,s10,s1
    80002af2:	9a6e                	add	s4,s4,s11
    80002af4:	0559f363          	bgeu	s3,s5,80002b3a <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002af8:	00a4d59b          	srliw	a1,s1,0xa
    80002afc:	855a                	mv	a0,s6
    80002afe:	987ff0ef          	jal	80002484 <bmap>
    80002b02:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b04:	c139                	beqz	a0,80002b4a <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b06:	000b2503          	lw	a0,0(s6)
    80002b0a:	e08ff0ef          	jal	80002112 <bread>
    80002b0e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b10:	3ff4f793          	andi	a5,s1,1023
    80002b14:	40fc873b          	subw	a4,s9,a5
    80002b18:	413a86bb          	subw	a3,s5,s3
    80002b1c:	8d3a                	mv	s10,a4
    80002b1e:	fae6f5e3          	bgeu	a3,a4,80002ac8 <readi+0x4c>
    80002b22:	8d36                	mv	s10,a3
    80002b24:	b755                	j	80002ac8 <readi+0x4c>
      brelse(bp);
    80002b26:	854a                	mv	a0,s2
    80002b28:	ef2ff0ef          	jal	8000221a <brelse>
      tot = -1;
    80002b2c:	59fd                	li	s3,-1
      break;
    80002b2e:	6946                	ld	s2,80(sp)
    80002b30:	7c02                	ld	s8,32(sp)
    80002b32:	6ce2                	ld	s9,24(sp)
    80002b34:	6d42                	ld	s10,16(sp)
    80002b36:	6da2                	ld	s11,8(sp)
    80002b38:	a831                	j	80002b54 <readi+0xd8>
    80002b3a:	6946                	ld	s2,80(sp)
    80002b3c:	7c02                	ld	s8,32(sp)
    80002b3e:	6ce2                	ld	s9,24(sp)
    80002b40:	6d42                	ld	s10,16(sp)
    80002b42:	6da2                	ld	s11,8(sp)
    80002b44:	a801                	j	80002b54 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b46:	89d6                	mv	s3,s5
    80002b48:	a031                	j	80002b54 <readi+0xd8>
    80002b4a:	6946                	ld	s2,80(sp)
    80002b4c:	7c02                	ld	s8,32(sp)
    80002b4e:	6ce2                	ld	s9,24(sp)
    80002b50:	6d42                	ld	s10,16(sp)
    80002b52:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b54:	854e                	mv	a0,s3
    80002b56:	69a6                	ld	s3,72(sp)
}
    80002b58:	70a6                	ld	ra,104(sp)
    80002b5a:	7406                	ld	s0,96(sp)
    80002b5c:	64e6                	ld	s1,88(sp)
    80002b5e:	6a06                	ld	s4,64(sp)
    80002b60:	7ae2                	ld	s5,56(sp)
    80002b62:	7b42                	ld	s6,48(sp)
    80002b64:	7ba2                	ld	s7,40(sp)
    80002b66:	6165                	addi	sp,sp,112
    80002b68:	8082                	ret
    return 0;
    80002b6a:	4501                	li	a0,0
}
    80002b6c:	8082                	ret

0000000080002b6e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b6e:	457c                	lw	a5,76(a0)
    80002b70:	0ed7eb63          	bltu	a5,a3,80002c66 <writei+0xf8>
{
    80002b74:	7159                	addi	sp,sp,-112
    80002b76:	f486                	sd	ra,104(sp)
    80002b78:	f0a2                	sd	s0,96(sp)
    80002b7a:	e8ca                	sd	s2,80(sp)
    80002b7c:	e0d2                	sd	s4,64(sp)
    80002b7e:	fc56                	sd	s5,56(sp)
    80002b80:	f85a                	sd	s6,48(sp)
    80002b82:	f45e                	sd	s7,40(sp)
    80002b84:	1880                	addi	s0,sp,112
    80002b86:	8aaa                	mv	s5,a0
    80002b88:	8bae                	mv	s7,a1
    80002b8a:	8a32                	mv	s4,a2
    80002b8c:	8936                	mv	s2,a3
    80002b8e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b90:	00e687bb          	addw	a5,a3,a4
    80002b94:	0cd7eb63          	bltu	a5,a3,80002c6a <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b98:	00043737          	lui	a4,0x43
    80002b9c:	0cf76963          	bltu	a4,a5,80002c6e <writei+0x100>
    80002ba0:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ba2:	0a0b0a63          	beqz	s6,80002c56 <writei+0xe8>
    80002ba6:	eca6                	sd	s1,88(sp)
    80002ba8:	f062                	sd	s8,32(sp)
    80002baa:	ec66                	sd	s9,24(sp)
    80002bac:	e86a                	sd	s10,16(sp)
    80002bae:	e46e                	sd	s11,8(sp)
    80002bb0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bb2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bb6:	5c7d                	li	s8,-1
    80002bb8:	a825                	j	80002bf0 <writei+0x82>
    80002bba:	020d1d93          	slli	s11,s10,0x20
    80002bbe:	020ddd93          	srli	s11,s11,0x20
    80002bc2:	05848513          	addi	a0,s1,88
    80002bc6:	86ee                	mv	a3,s11
    80002bc8:	8652                	mv	a2,s4
    80002bca:	85de                	mv	a1,s7
    80002bcc:	953e                	add	a0,a0,a5
    80002bce:	bf9fe0ef          	jal	800017c6 <either_copyin>
    80002bd2:	05850663          	beq	a0,s8,80002c1e <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	688000ef          	jal	80003260 <log_write>
    brelse(bp);
    80002bdc:	8526                	mv	a0,s1
    80002bde:	e3cff0ef          	jal	8000221a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002be2:	013d09bb          	addw	s3,s10,s3
    80002be6:	012d093b          	addw	s2,s10,s2
    80002bea:	9a6e                	add	s4,s4,s11
    80002bec:	0369fc63          	bgeu	s3,s6,80002c24 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002bf0:	00a9559b          	srliw	a1,s2,0xa
    80002bf4:	8556                	mv	a0,s5
    80002bf6:	88fff0ef          	jal	80002484 <bmap>
    80002bfa:	85aa                	mv	a1,a0
    if(addr == 0)
    80002bfc:	c505                	beqz	a0,80002c24 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002bfe:	000aa503          	lw	a0,0(s5)
    80002c02:	d10ff0ef          	jal	80002112 <bread>
    80002c06:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c08:	3ff97793          	andi	a5,s2,1023
    80002c0c:	40fc873b          	subw	a4,s9,a5
    80002c10:	413b06bb          	subw	a3,s6,s3
    80002c14:	8d3a                	mv	s10,a4
    80002c16:	fae6f2e3          	bgeu	a3,a4,80002bba <writei+0x4c>
    80002c1a:	8d36                	mv	s10,a3
    80002c1c:	bf79                	j	80002bba <writei+0x4c>
      brelse(bp);
    80002c1e:	8526                	mv	a0,s1
    80002c20:	dfaff0ef          	jal	8000221a <brelse>
  }

  if(off > ip->size)
    80002c24:	04caa783          	lw	a5,76(s5)
    80002c28:	0327f963          	bgeu	a5,s2,80002c5a <writei+0xec>
    ip->size = off;
    80002c2c:	052aa623          	sw	s2,76(s5)
    80002c30:	64e6                	ld	s1,88(sp)
    80002c32:	7c02                	ld	s8,32(sp)
    80002c34:	6ce2                	ld	s9,24(sp)
    80002c36:	6d42                	ld	s10,16(sp)
    80002c38:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c3a:	8556                	mv	a0,s5
    80002c3c:	b35ff0ef          	jal	80002770 <iupdate>

  return tot;
    80002c40:	854e                	mv	a0,s3
    80002c42:	69a6                	ld	s3,72(sp)
}
    80002c44:	70a6                	ld	ra,104(sp)
    80002c46:	7406                	ld	s0,96(sp)
    80002c48:	6946                	ld	s2,80(sp)
    80002c4a:	6a06                	ld	s4,64(sp)
    80002c4c:	7ae2                	ld	s5,56(sp)
    80002c4e:	7b42                	ld	s6,48(sp)
    80002c50:	7ba2                	ld	s7,40(sp)
    80002c52:	6165                	addi	sp,sp,112
    80002c54:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c56:	89da                	mv	s3,s6
    80002c58:	b7cd                	j	80002c3a <writei+0xcc>
    80002c5a:	64e6                	ld	s1,88(sp)
    80002c5c:	7c02                	ld	s8,32(sp)
    80002c5e:	6ce2                	ld	s9,24(sp)
    80002c60:	6d42                	ld	s10,16(sp)
    80002c62:	6da2                	ld	s11,8(sp)
    80002c64:	bfd9                	j	80002c3a <writei+0xcc>
    return -1;
    80002c66:	557d                	li	a0,-1
}
    80002c68:	8082                	ret
    return -1;
    80002c6a:	557d                	li	a0,-1
    80002c6c:	bfe1                	j	80002c44 <writei+0xd6>
    return -1;
    80002c6e:	557d                	li	a0,-1
    80002c70:	bfd1                	j	80002c44 <writei+0xd6>

0000000080002c72 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c72:	1141                	addi	sp,sp,-16
    80002c74:	e406                	sd	ra,8(sp)
    80002c76:	e022                	sd	s0,0(sp)
    80002c78:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c7a:	4639                	li	a2,14
    80002c7c:	daafd0ef          	jal	80000226 <strncmp>
}
    80002c80:	60a2                	ld	ra,8(sp)
    80002c82:	6402                	ld	s0,0(sp)
    80002c84:	0141                	addi	sp,sp,16
    80002c86:	8082                	ret

0000000080002c88 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c88:	711d                	addi	sp,sp,-96
    80002c8a:	ec86                	sd	ra,88(sp)
    80002c8c:	e8a2                	sd	s0,80(sp)
    80002c8e:	e4a6                	sd	s1,72(sp)
    80002c90:	e0ca                	sd	s2,64(sp)
    80002c92:	fc4e                	sd	s3,56(sp)
    80002c94:	f852                	sd	s4,48(sp)
    80002c96:	f456                	sd	s5,40(sp)
    80002c98:	f05a                	sd	s6,32(sp)
    80002c9a:	ec5e                	sd	s7,24(sp)
    80002c9c:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c9e:	04451703          	lh	a4,68(a0)
    80002ca2:	4785                	li	a5,1
    80002ca4:	00f71f63          	bne	a4,a5,80002cc2 <dirlookup+0x3a>
    80002ca8:	892a                	mv	s2,a0
    80002caa:	8aae                	mv	s5,a1
    80002cac:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cae:	457c                	lw	a5,76(a0)
    80002cb0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cb2:	fa040a13          	addi	s4,s0,-96
    80002cb6:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002cb8:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002cbc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cbe:	e39d                	bnez	a5,80002ce4 <dirlookup+0x5c>
    80002cc0:	a8b9                	j	80002d1e <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002cc2:	00005517          	auipc	a0,0x5
    80002cc6:	83e50513          	addi	a0,a0,-1986 # 80007500 <etext+0x500>
    80002cca:	14d020ef          	jal	80005616 <panic>
      panic("dirlookup read");
    80002cce:	00005517          	auipc	a0,0x5
    80002cd2:	84a50513          	addi	a0,a0,-1974 # 80007518 <etext+0x518>
    80002cd6:	141020ef          	jal	80005616 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cda:	24c1                	addiw	s1,s1,16
    80002cdc:	04c92783          	lw	a5,76(s2)
    80002ce0:	02f4fe63          	bgeu	s1,a5,80002d1c <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ce4:	874e                	mv	a4,s3
    80002ce6:	86a6                	mv	a3,s1
    80002ce8:	8652                	mv	a2,s4
    80002cea:	4581                	li	a1,0
    80002cec:	854a                	mv	a0,s2
    80002cee:	d8fff0ef          	jal	80002a7c <readi>
    80002cf2:	fd351ee3          	bne	a0,s3,80002cce <dirlookup+0x46>
    if(de.inum == 0)
    80002cf6:	fa045783          	lhu	a5,-96(s0)
    80002cfa:	d3e5                	beqz	a5,80002cda <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002cfc:	85da                	mv	a1,s6
    80002cfe:	8556                	mv	a0,s5
    80002d00:	f73ff0ef          	jal	80002c72 <namecmp>
    80002d04:	f979                	bnez	a0,80002cda <dirlookup+0x52>
      if(poff)
    80002d06:	000b8463          	beqz	s7,80002d0e <dirlookup+0x86>
        *poff = off;
    80002d0a:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d0e:	fa045583          	lhu	a1,-96(s0)
    80002d12:	00092503          	lw	a0,0(s2)
    80002d16:	82fff0ef          	jal	80002544 <iget>
    80002d1a:	a011                	j	80002d1e <dirlookup+0x96>
  return 0;
    80002d1c:	4501                	li	a0,0
}
    80002d1e:	60e6                	ld	ra,88(sp)
    80002d20:	6446                	ld	s0,80(sp)
    80002d22:	64a6                	ld	s1,72(sp)
    80002d24:	6906                	ld	s2,64(sp)
    80002d26:	79e2                	ld	s3,56(sp)
    80002d28:	7a42                	ld	s4,48(sp)
    80002d2a:	7aa2                	ld	s5,40(sp)
    80002d2c:	7b02                	ld	s6,32(sp)
    80002d2e:	6be2                	ld	s7,24(sp)
    80002d30:	6125                	addi	sp,sp,96
    80002d32:	8082                	ret

0000000080002d34 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d34:	711d                	addi	sp,sp,-96
    80002d36:	ec86                	sd	ra,88(sp)
    80002d38:	e8a2                	sd	s0,80(sp)
    80002d3a:	e4a6                	sd	s1,72(sp)
    80002d3c:	e0ca                	sd	s2,64(sp)
    80002d3e:	fc4e                	sd	s3,56(sp)
    80002d40:	f852                	sd	s4,48(sp)
    80002d42:	f456                	sd	s5,40(sp)
    80002d44:	f05a                	sd	s6,32(sp)
    80002d46:	ec5e                	sd	s7,24(sp)
    80002d48:	e862                	sd	s8,16(sp)
    80002d4a:	e466                	sd	s9,8(sp)
    80002d4c:	e06a                	sd	s10,0(sp)
    80002d4e:	1080                	addi	s0,sp,96
    80002d50:	84aa                	mv	s1,a0
    80002d52:	8b2e                	mv	s6,a1
    80002d54:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d56:	00054703          	lbu	a4,0(a0)
    80002d5a:	02f00793          	li	a5,47
    80002d5e:	00f70f63          	beq	a4,a5,80002d7c <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d62:	8f6fe0ef          	jal	80000e58 <myproc>
    80002d66:	15053503          	ld	a0,336(a0)
    80002d6a:	a85ff0ef          	jal	800027ee <idup>
    80002d6e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d70:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d74:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002d76:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d78:	4b85                	li	s7,1
    80002d7a:	a879                	j	80002e18 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002d7c:	4585                	li	a1,1
    80002d7e:	852e                	mv	a0,a1
    80002d80:	fc4ff0ef          	jal	80002544 <iget>
    80002d84:	8a2a                	mv	s4,a0
    80002d86:	b7ed                	j	80002d70 <namex+0x3c>
      iunlockput(ip);
    80002d88:	8552                	mv	a0,s4
    80002d8a:	ca5ff0ef          	jal	80002a2e <iunlockput>
      return 0;
    80002d8e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d90:	8552                	mv	a0,s4
    80002d92:	60e6                	ld	ra,88(sp)
    80002d94:	6446                	ld	s0,80(sp)
    80002d96:	64a6                	ld	s1,72(sp)
    80002d98:	6906                	ld	s2,64(sp)
    80002d9a:	79e2                	ld	s3,56(sp)
    80002d9c:	7a42                	ld	s4,48(sp)
    80002d9e:	7aa2                	ld	s5,40(sp)
    80002da0:	7b02                	ld	s6,32(sp)
    80002da2:	6be2                	ld	s7,24(sp)
    80002da4:	6c42                	ld	s8,16(sp)
    80002da6:	6ca2                	ld	s9,8(sp)
    80002da8:	6d02                	ld	s10,0(sp)
    80002daa:	6125                	addi	sp,sp,96
    80002dac:	8082                	ret
      iunlock(ip);
    80002dae:	8552                	mv	a0,s4
    80002db0:	b23ff0ef          	jal	800028d2 <iunlock>
      return ip;
    80002db4:	bff1                	j	80002d90 <namex+0x5c>
      iunlockput(ip);
    80002db6:	8552                	mv	a0,s4
    80002db8:	c77ff0ef          	jal	80002a2e <iunlockput>
      return 0;
    80002dbc:	8a4e                	mv	s4,s3
    80002dbe:	bfc9                	j	80002d90 <namex+0x5c>
  len = path - s;
    80002dc0:	40998633          	sub	a2,s3,s1
    80002dc4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002dc8:	09ac5063          	bge	s8,s10,80002e48 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002dcc:	8666                	mv	a2,s9
    80002dce:	85a6                	mv	a1,s1
    80002dd0:	8556                	mv	a0,s5
    80002dd2:	be0fd0ef          	jal	800001b2 <memmove>
    80002dd6:	84ce                	mv	s1,s3
  while(*path == '/')
    80002dd8:	0004c783          	lbu	a5,0(s1)
    80002ddc:	01279763          	bne	a5,s2,80002dea <namex+0xb6>
    path++;
    80002de0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002de2:	0004c783          	lbu	a5,0(s1)
    80002de6:	ff278de3          	beq	a5,s2,80002de0 <namex+0xac>
    ilock(ip);
    80002dea:	8552                	mv	a0,s4
    80002dec:	a39ff0ef          	jal	80002824 <ilock>
    if(ip->type != T_DIR){
    80002df0:	044a1783          	lh	a5,68(s4)
    80002df4:	f9779ae3          	bne	a5,s7,80002d88 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002df8:	000b0563          	beqz	s6,80002e02 <namex+0xce>
    80002dfc:	0004c783          	lbu	a5,0(s1)
    80002e00:	d7dd                	beqz	a5,80002dae <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e02:	4601                	li	a2,0
    80002e04:	85d6                	mv	a1,s5
    80002e06:	8552                	mv	a0,s4
    80002e08:	e81ff0ef          	jal	80002c88 <dirlookup>
    80002e0c:	89aa                	mv	s3,a0
    80002e0e:	d545                	beqz	a0,80002db6 <namex+0x82>
    iunlockput(ip);
    80002e10:	8552                	mv	a0,s4
    80002e12:	c1dff0ef          	jal	80002a2e <iunlockput>
    ip = next;
    80002e16:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002e18:	0004c783          	lbu	a5,0(s1)
    80002e1c:	01279763          	bne	a5,s2,80002e2a <namex+0xf6>
    path++;
    80002e20:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e22:	0004c783          	lbu	a5,0(s1)
    80002e26:	ff278de3          	beq	a5,s2,80002e20 <namex+0xec>
  if(*path == 0)
    80002e2a:	cb8d                	beqz	a5,80002e5c <namex+0x128>
  while(*path != '/' && *path != 0)
    80002e2c:	0004c783          	lbu	a5,0(s1)
    80002e30:	89a6                	mv	s3,s1
  len = path - s;
    80002e32:	4d01                	li	s10,0
    80002e34:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e36:	01278963          	beq	a5,s2,80002e48 <namex+0x114>
    80002e3a:	d3d9                	beqz	a5,80002dc0 <namex+0x8c>
    path++;
    80002e3c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e3e:	0009c783          	lbu	a5,0(s3)
    80002e42:	ff279ce3          	bne	a5,s2,80002e3a <namex+0x106>
    80002e46:	bfad                	j	80002dc0 <namex+0x8c>
    memmove(name, s, len);
    80002e48:	2601                	sext.w	a2,a2
    80002e4a:	85a6                	mv	a1,s1
    80002e4c:	8556                	mv	a0,s5
    80002e4e:	b64fd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002e52:	9d56                	add	s10,s10,s5
    80002e54:	000d0023          	sb	zero,0(s10)
    80002e58:	84ce                	mv	s1,s3
    80002e5a:	bfbd                	j	80002dd8 <namex+0xa4>
  if(nameiparent){
    80002e5c:	f20b0ae3          	beqz	s6,80002d90 <namex+0x5c>
    iput(ip);
    80002e60:	8552                	mv	a0,s4
    80002e62:	b45ff0ef          	jal	800029a6 <iput>
    return 0;
    80002e66:	4a01                	li	s4,0
    80002e68:	b725                	j	80002d90 <namex+0x5c>

0000000080002e6a <dirlink>:
{
    80002e6a:	715d                	addi	sp,sp,-80
    80002e6c:	e486                	sd	ra,72(sp)
    80002e6e:	e0a2                	sd	s0,64(sp)
    80002e70:	f84a                	sd	s2,48(sp)
    80002e72:	ec56                	sd	s5,24(sp)
    80002e74:	e85a                	sd	s6,16(sp)
    80002e76:	0880                	addi	s0,sp,80
    80002e78:	892a                	mv	s2,a0
    80002e7a:	8aae                	mv	s5,a1
    80002e7c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e7e:	4601                	li	a2,0
    80002e80:	e09ff0ef          	jal	80002c88 <dirlookup>
    80002e84:	ed1d                	bnez	a0,80002ec2 <dirlink+0x58>
    80002e86:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e88:	04c92483          	lw	s1,76(s2)
    80002e8c:	c4b9                	beqz	s1,80002eda <dirlink+0x70>
    80002e8e:	f44e                	sd	s3,40(sp)
    80002e90:	f052                	sd	s4,32(sp)
    80002e92:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e94:	fb040a13          	addi	s4,s0,-80
    80002e98:	49c1                	li	s3,16
    80002e9a:	874e                	mv	a4,s3
    80002e9c:	86a6                	mv	a3,s1
    80002e9e:	8652                	mv	a2,s4
    80002ea0:	4581                	li	a1,0
    80002ea2:	854a                	mv	a0,s2
    80002ea4:	bd9ff0ef          	jal	80002a7c <readi>
    80002ea8:	03351163          	bne	a0,s3,80002eca <dirlink+0x60>
    if(de.inum == 0)
    80002eac:	fb045783          	lhu	a5,-80(s0)
    80002eb0:	c39d                	beqz	a5,80002ed6 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eb2:	24c1                	addiw	s1,s1,16
    80002eb4:	04c92783          	lw	a5,76(s2)
    80002eb8:	fef4e1e3          	bltu	s1,a5,80002e9a <dirlink+0x30>
    80002ebc:	79a2                	ld	s3,40(sp)
    80002ebe:	7a02                	ld	s4,32(sp)
    80002ec0:	a829                	j	80002eda <dirlink+0x70>
    iput(ip);
    80002ec2:	ae5ff0ef          	jal	800029a6 <iput>
    return -1;
    80002ec6:	557d                	li	a0,-1
    80002ec8:	a83d                	j	80002f06 <dirlink+0x9c>
      panic("dirlink read");
    80002eca:	00004517          	auipc	a0,0x4
    80002ece:	65e50513          	addi	a0,a0,1630 # 80007528 <etext+0x528>
    80002ed2:	744020ef          	jal	80005616 <panic>
    80002ed6:	79a2                	ld	s3,40(sp)
    80002ed8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002eda:	4639                	li	a2,14
    80002edc:	85d6                	mv	a1,s5
    80002ede:	fb240513          	addi	a0,s0,-78
    80002ee2:	b7efd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002ee6:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eea:	4741                	li	a4,16
    80002eec:	86a6                	mv	a3,s1
    80002eee:	fb040613          	addi	a2,s0,-80
    80002ef2:	4581                	li	a1,0
    80002ef4:	854a                	mv	a0,s2
    80002ef6:	c79ff0ef          	jal	80002b6e <writei>
    80002efa:	1541                	addi	a0,a0,-16
    80002efc:	00a03533          	snez	a0,a0
    80002f00:	40a0053b          	negw	a0,a0
    80002f04:	74e2                	ld	s1,56(sp)
}
    80002f06:	60a6                	ld	ra,72(sp)
    80002f08:	6406                	ld	s0,64(sp)
    80002f0a:	7942                	ld	s2,48(sp)
    80002f0c:	6ae2                	ld	s5,24(sp)
    80002f0e:	6b42                	ld	s6,16(sp)
    80002f10:	6161                	addi	sp,sp,80
    80002f12:	8082                	ret

0000000080002f14 <namei>:

struct inode*
namei(char *path)
{
    80002f14:	1101                	addi	sp,sp,-32
    80002f16:	ec06                	sd	ra,24(sp)
    80002f18:	e822                	sd	s0,16(sp)
    80002f1a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f1c:	fe040613          	addi	a2,s0,-32
    80002f20:	4581                	li	a1,0
    80002f22:	e13ff0ef          	jal	80002d34 <namex>
}
    80002f26:	60e2                	ld	ra,24(sp)
    80002f28:	6442                	ld	s0,16(sp)
    80002f2a:	6105                	addi	sp,sp,32
    80002f2c:	8082                	ret

0000000080002f2e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f2e:	1141                	addi	sp,sp,-16
    80002f30:	e406                	sd	ra,8(sp)
    80002f32:	e022                	sd	s0,0(sp)
    80002f34:	0800                	addi	s0,sp,16
    80002f36:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f38:	4585                	li	a1,1
    80002f3a:	dfbff0ef          	jal	80002d34 <namex>
}
    80002f3e:	60a2                	ld	ra,8(sp)
    80002f40:	6402                	ld	s0,0(sp)
    80002f42:	0141                	addi	sp,sp,16
    80002f44:	8082                	ret

0000000080002f46 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f46:	1101                	addi	sp,sp,-32
    80002f48:	ec06                	sd	ra,24(sp)
    80002f4a:	e822                	sd	s0,16(sp)
    80002f4c:	e426                	sd	s1,8(sp)
    80002f4e:	e04a                	sd	s2,0(sp)
    80002f50:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f52:	00017917          	auipc	s2,0x17
    80002f56:	54e90913          	addi	s2,s2,1358 # 8001a4a0 <log>
    80002f5a:	01892583          	lw	a1,24(s2)
    80002f5e:	02892503          	lw	a0,40(s2)
    80002f62:	9b0ff0ef          	jal	80002112 <bread>
    80002f66:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f68:	02c92603          	lw	a2,44(s2)
    80002f6c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f6e:	00c05f63          	blez	a2,80002f8c <write_head+0x46>
    80002f72:	00017717          	auipc	a4,0x17
    80002f76:	55e70713          	addi	a4,a4,1374 # 8001a4d0 <log+0x30>
    80002f7a:	87aa                	mv	a5,a0
    80002f7c:	060a                	slli	a2,a2,0x2
    80002f7e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f80:	4314                	lw	a3,0(a4)
    80002f82:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f84:	0711                	addi	a4,a4,4
    80002f86:	0791                	addi	a5,a5,4
    80002f88:	fec79ce3          	bne	a5,a2,80002f80 <write_head+0x3a>
  }
  bwrite(buf);
    80002f8c:	8526                	mv	a0,s1
    80002f8e:	a5aff0ef          	jal	800021e8 <bwrite>
  brelse(buf);
    80002f92:	8526                	mv	a0,s1
    80002f94:	a86ff0ef          	jal	8000221a <brelse>
}
    80002f98:	60e2                	ld	ra,24(sp)
    80002f9a:	6442                	ld	s0,16(sp)
    80002f9c:	64a2                	ld	s1,8(sp)
    80002f9e:	6902                	ld	s2,0(sp)
    80002fa0:	6105                	addi	sp,sp,32
    80002fa2:	8082                	ret

0000000080002fa4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa4:	00017797          	auipc	a5,0x17
    80002fa8:	5287a783          	lw	a5,1320(a5) # 8001a4cc <log+0x2c>
    80002fac:	0af05263          	blez	a5,80003050 <install_trans+0xac>
{
    80002fb0:	715d                	addi	sp,sp,-80
    80002fb2:	e486                	sd	ra,72(sp)
    80002fb4:	e0a2                	sd	s0,64(sp)
    80002fb6:	fc26                	sd	s1,56(sp)
    80002fb8:	f84a                	sd	s2,48(sp)
    80002fba:	f44e                	sd	s3,40(sp)
    80002fbc:	f052                	sd	s4,32(sp)
    80002fbe:	ec56                	sd	s5,24(sp)
    80002fc0:	e85a                	sd	s6,16(sp)
    80002fc2:	e45e                	sd	s7,8(sp)
    80002fc4:	0880                	addi	s0,sp,80
    80002fc6:	8b2a                	mv	s6,a0
    80002fc8:	00017a97          	auipc	s5,0x17
    80002fcc:	508a8a93          	addi	s5,s5,1288 # 8001a4d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fd2:	00017997          	auipc	s3,0x17
    80002fd6:	4ce98993          	addi	s3,s3,1230 # 8001a4a0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fda:	40000b93          	li	s7,1024
    80002fde:	a829                	j	80002ff8 <install_trans+0x54>
    brelse(lbuf);
    80002fe0:	854a                	mv	a0,s2
    80002fe2:	a38ff0ef          	jal	8000221a <brelse>
    brelse(dbuf);
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	a32ff0ef          	jal	8000221a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fec:	2a05                	addiw	s4,s4,1
    80002fee:	0a91                	addi	s5,s5,4
    80002ff0:	02c9a783          	lw	a5,44(s3)
    80002ff4:	04fa5363          	bge	s4,a5,8000303a <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ff8:	0189a583          	lw	a1,24(s3)
    80002ffc:	014585bb          	addw	a1,a1,s4
    80003000:	2585                	addiw	a1,a1,1
    80003002:	0289a503          	lw	a0,40(s3)
    80003006:	90cff0ef          	jal	80002112 <bread>
    8000300a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000300c:	000aa583          	lw	a1,0(s5)
    80003010:	0289a503          	lw	a0,40(s3)
    80003014:	8feff0ef          	jal	80002112 <bread>
    80003018:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000301a:	865e                	mv	a2,s7
    8000301c:	05890593          	addi	a1,s2,88
    80003020:	05850513          	addi	a0,a0,88
    80003024:	98efd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003028:	8526                	mv	a0,s1
    8000302a:	9beff0ef          	jal	800021e8 <bwrite>
    if(recovering == 0)
    8000302e:	fa0b19e3          	bnez	s6,80002fe0 <install_trans+0x3c>
      bunpin(dbuf);
    80003032:	8526                	mv	a0,s1
    80003034:	a9eff0ef          	jal	800022d2 <bunpin>
    80003038:	b765                	j	80002fe0 <install_trans+0x3c>
}
    8000303a:	60a6                	ld	ra,72(sp)
    8000303c:	6406                	ld	s0,64(sp)
    8000303e:	74e2                	ld	s1,56(sp)
    80003040:	7942                	ld	s2,48(sp)
    80003042:	79a2                	ld	s3,40(sp)
    80003044:	7a02                	ld	s4,32(sp)
    80003046:	6ae2                	ld	s5,24(sp)
    80003048:	6b42                	ld	s6,16(sp)
    8000304a:	6ba2                	ld	s7,8(sp)
    8000304c:	6161                	addi	sp,sp,80
    8000304e:	8082                	ret
    80003050:	8082                	ret

0000000080003052 <initlog>:
{
    80003052:	7179                	addi	sp,sp,-48
    80003054:	f406                	sd	ra,40(sp)
    80003056:	f022                	sd	s0,32(sp)
    80003058:	ec26                	sd	s1,24(sp)
    8000305a:	e84a                	sd	s2,16(sp)
    8000305c:	e44e                	sd	s3,8(sp)
    8000305e:	1800                	addi	s0,sp,48
    80003060:	892a                	mv	s2,a0
    80003062:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003064:	00017497          	auipc	s1,0x17
    80003068:	43c48493          	addi	s1,s1,1084 # 8001a4a0 <log>
    8000306c:	00004597          	auipc	a1,0x4
    80003070:	4cc58593          	addi	a1,a1,1228 # 80007538 <etext+0x538>
    80003074:	8526                	mv	a0,s1
    80003076:	04b020ef          	jal	800058c0 <initlock>
  log.start = sb->logstart;
    8000307a:	0149a583          	lw	a1,20(s3)
    8000307e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003080:	0109a783          	lw	a5,16(s3)
    80003084:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003086:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000308a:	854a                	mv	a0,s2
    8000308c:	886ff0ef          	jal	80002112 <bread>
  log.lh.n = lh->n;
    80003090:	4d30                	lw	a2,88(a0)
    80003092:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003094:	00c05f63          	blez	a2,800030b2 <initlog+0x60>
    80003098:	87aa                	mv	a5,a0
    8000309a:	00017717          	auipc	a4,0x17
    8000309e:	43670713          	addi	a4,a4,1078 # 8001a4d0 <log+0x30>
    800030a2:	060a                	slli	a2,a2,0x2
    800030a4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800030a6:	4ff4                	lw	a3,92(a5)
    800030a8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800030aa:	0791                	addi	a5,a5,4
    800030ac:	0711                	addi	a4,a4,4
    800030ae:	fec79ce3          	bne	a5,a2,800030a6 <initlog+0x54>
  brelse(buf);
    800030b2:	968ff0ef          	jal	8000221a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030b6:	4505                	li	a0,1
    800030b8:	eedff0ef          	jal	80002fa4 <install_trans>
  log.lh.n = 0;
    800030bc:	00017797          	auipc	a5,0x17
    800030c0:	4007a823          	sw	zero,1040(a5) # 8001a4cc <log+0x2c>
  write_head(); // clear the log
    800030c4:	e83ff0ef          	jal	80002f46 <write_head>
}
    800030c8:	70a2                	ld	ra,40(sp)
    800030ca:	7402                	ld	s0,32(sp)
    800030cc:	64e2                	ld	s1,24(sp)
    800030ce:	6942                	ld	s2,16(sp)
    800030d0:	69a2                	ld	s3,8(sp)
    800030d2:	6145                	addi	sp,sp,48
    800030d4:	8082                	ret

00000000800030d6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030d6:	1101                	addi	sp,sp,-32
    800030d8:	ec06                	sd	ra,24(sp)
    800030da:	e822                	sd	s0,16(sp)
    800030dc:	e426                	sd	s1,8(sp)
    800030de:	e04a                	sd	s2,0(sp)
    800030e0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030e2:	00017517          	auipc	a0,0x17
    800030e6:	3be50513          	addi	a0,a0,958 # 8001a4a0 <log>
    800030ea:	05b020ef          	jal	80005944 <acquire>
  while(1){
    if(log.committing){
    800030ee:	00017497          	auipc	s1,0x17
    800030f2:	3b248493          	addi	s1,s1,946 # 8001a4a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030f6:	4979                	li	s2,30
    800030f8:	a029                	j	80003102 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030fa:	85a6                	mv	a1,s1
    800030fc:	8526                	mv	a0,s1
    800030fe:	b28fe0ef          	jal	80001426 <sleep>
    if(log.committing){
    80003102:	50dc                	lw	a5,36(s1)
    80003104:	fbfd                	bnez	a5,800030fa <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003106:	5098                	lw	a4,32(s1)
    80003108:	2705                	addiw	a4,a4,1
    8000310a:	0027179b          	slliw	a5,a4,0x2
    8000310e:	9fb9                	addw	a5,a5,a4
    80003110:	0017979b          	slliw	a5,a5,0x1
    80003114:	54d4                	lw	a3,44(s1)
    80003116:	9fb5                	addw	a5,a5,a3
    80003118:	00f95763          	bge	s2,a5,80003126 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000311c:	85a6                	mv	a1,s1
    8000311e:	8526                	mv	a0,s1
    80003120:	b06fe0ef          	jal	80001426 <sleep>
    80003124:	bff9                	j	80003102 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003126:	00017517          	auipc	a0,0x17
    8000312a:	37a50513          	addi	a0,a0,890 # 8001a4a0 <log>
    8000312e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003130:	0a9020ef          	jal	800059d8 <release>
      break;
    }
  }
}
    80003134:	60e2                	ld	ra,24(sp)
    80003136:	6442                	ld	s0,16(sp)
    80003138:	64a2                	ld	s1,8(sp)
    8000313a:	6902                	ld	s2,0(sp)
    8000313c:	6105                	addi	sp,sp,32
    8000313e:	8082                	ret

0000000080003140 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003140:	7139                	addi	sp,sp,-64
    80003142:	fc06                	sd	ra,56(sp)
    80003144:	f822                	sd	s0,48(sp)
    80003146:	f426                	sd	s1,40(sp)
    80003148:	f04a                	sd	s2,32(sp)
    8000314a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000314c:	00017497          	auipc	s1,0x17
    80003150:	35448493          	addi	s1,s1,852 # 8001a4a0 <log>
    80003154:	8526                	mv	a0,s1
    80003156:	7ee020ef          	jal	80005944 <acquire>
  log.outstanding -= 1;
    8000315a:	509c                	lw	a5,32(s1)
    8000315c:	37fd                	addiw	a5,a5,-1
    8000315e:	893e                	mv	s2,a5
    80003160:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003162:	50dc                	lw	a5,36(s1)
    80003164:	ef9d                	bnez	a5,800031a2 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003166:	04091863          	bnez	s2,800031b6 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000316a:	00017497          	auipc	s1,0x17
    8000316e:	33648493          	addi	s1,s1,822 # 8001a4a0 <log>
    80003172:	4785                	li	a5,1
    80003174:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003176:	8526                	mv	a0,s1
    80003178:	061020ef          	jal	800059d8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000317c:	54dc                	lw	a5,44(s1)
    8000317e:	04f04c63          	bgtz	a5,800031d6 <end_op+0x96>
    acquire(&log.lock);
    80003182:	00017497          	auipc	s1,0x17
    80003186:	31e48493          	addi	s1,s1,798 # 8001a4a0 <log>
    8000318a:	8526                	mv	a0,s1
    8000318c:	7b8020ef          	jal	80005944 <acquire>
    log.committing = 0;
    80003190:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003194:	8526                	mv	a0,s1
    80003196:	adcfe0ef          	jal	80001472 <wakeup>
    release(&log.lock);
    8000319a:	8526                	mv	a0,s1
    8000319c:	03d020ef          	jal	800059d8 <release>
}
    800031a0:	a02d                	j	800031ca <end_op+0x8a>
    800031a2:	ec4e                	sd	s3,24(sp)
    800031a4:	e852                	sd	s4,16(sp)
    800031a6:	e456                	sd	s5,8(sp)
    800031a8:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800031aa:	00004517          	auipc	a0,0x4
    800031ae:	39650513          	addi	a0,a0,918 # 80007540 <etext+0x540>
    800031b2:	464020ef          	jal	80005616 <panic>
    wakeup(&log);
    800031b6:	00017497          	auipc	s1,0x17
    800031ba:	2ea48493          	addi	s1,s1,746 # 8001a4a0 <log>
    800031be:	8526                	mv	a0,s1
    800031c0:	ab2fe0ef          	jal	80001472 <wakeup>
  release(&log.lock);
    800031c4:	8526                	mv	a0,s1
    800031c6:	013020ef          	jal	800059d8 <release>
}
    800031ca:	70e2                	ld	ra,56(sp)
    800031cc:	7442                	ld	s0,48(sp)
    800031ce:	74a2                	ld	s1,40(sp)
    800031d0:	7902                	ld	s2,32(sp)
    800031d2:	6121                	addi	sp,sp,64
    800031d4:	8082                	ret
    800031d6:	ec4e                	sd	s3,24(sp)
    800031d8:	e852                	sd	s4,16(sp)
    800031da:	e456                	sd	s5,8(sp)
    800031dc:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031de:	00017a97          	auipc	s5,0x17
    800031e2:	2f2a8a93          	addi	s5,s5,754 # 8001a4d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031e6:	00017a17          	auipc	s4,0x17
    800031ea:	2baa0a13          	addi	s4,s4,698 # 8001a4a0 <log>
    memmove(to->data, from->data, BSIZE);
    800031ee:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031f2:	018a2583          	lw	a1,24(s4)
    800031f6:	012585bb          	addw	a1,a1,s2
    800031fa:	2585                	addiw	a1,a1,1
    800031fc:	028a2503          	lw	a0,40(s4)
    80003200:	f13fe0ef          	jal	80002112 <bread>
    80003204:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003206:	000aa583          	lw	a1,0(s5)
    8000320a:	028a2503          	lw	a0,40(s4)
    8000320e:	f05fe0ef          	jal	80002112 <bread>
    80003212:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003214:	865a                	mv	a2,s6
    80003216:	05850593          	addi	a1,a0,88
    8000321a:	05848513          	addi	a0,s1,88
    8000321e:	f95fc0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    80003222:	8526                	mv	a0,s1
    80003224:	fc5fe0ef          	jal	800021e8 <bwrite>
    brelse(from);
    80003228:	854e                	mv	a0,s3
    8000322a:	ff1fe0ef          	jal	8000221a <brelse>
    brelse(to);
    8000322e:	8526                	mv	a0,s1
    80003230:	febfe0ef          	jal	8000221a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003234:	2905                	addiw	s2,s2,1
    80003236:	0a91                	addi	s5,s5,4
    80003238:	02ca2783          	lw	a5,44(s4)
    8000323c:	faf94be3          	blt	s2,a5,800031f2 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003240:	d07ff0ef          	jal	80002f46 <write_head>
    install_trans(0); // Now install writes to home locations
    80003244:	4501                	li	a0,0
    80003246:	d5fff0ef          	jal	80002fa4 <install_trans>
    log.lh.n = 0;
    8000324a:	00017797          	auipc	a5,0x17
    8000324e:	2807a123          	sw	zero,642(a5) # 8001a4cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003252:	cf5ff0ef          	jal	80002f46 <write_head>
    80003256:	69e2                	ld	s3,24(sp)
    80003258:	6a42                	ld	s4,16(sp)
    8000325a:	6aa2                	ld	s5,8(sp)
    8000325c:	6b02                	ld	s6,0(sp)
    8000325e:	b715                	j	80003182 <end_op+0x42>

0000000080003260 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003260:	1101                	addi	sp,sp,-32
    80003262:	ec06                	sd	ra,24(sp)
    80003264:	e822                	sd	s0,16(sp)
    80003266:	e426                	sd	s1,8(sp)
    80003268:	e04a                	sd	s2,0(sp)
    8000326a:	1000                	addi	s0,sp,32
    8000326c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000326e:	00017917          	auipc	s2,0x17
    80003272:	23290913          	addi	s2,s2,562 # 8001a4a0 <log>
    80003276:	854a                	mv	a0,s2
    80003278:	6cc020ef          	jal	80005944 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000327c:	02c92603          	lw	a2,44(s2)
    80003280:	47f5                	li	a5,29
    80003282:	06c7c363          	blt	a5,a2,800032e8 <log_write+0x88>
    80003286:	00017797          	auipc	a5,0x17
    8000328a:	2367a783          	lw	a5,566(a5) # 8001a4bc <log+0x1c>
    8000328e:	37fd                	addiw	a5,a5,-1
    80003290:	04f65c63          	bge	a2,a5,800032e8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003294:	00017797          	auipc	a5,0x17
    80003298:	22c7a783          	lw	a5,556(a5) # 8001a4c0 <log+0x20>
    8000329c:	04f05c63          	blez	a5,800032f4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800032a0:	4781                	li	a5,0
    800032a2:	04c05f63          	blez	a2,80003300 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032a6:	44cc                	lw	a1,12(s1)
    800032a8:	00017717          	auipc	a4,0x17
    800032ac:	22870713          	addi	a4,a4,552 # 8001a4d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800032b0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032b2:	4314                	lw	a3,0(a4)
    800032b4:	04b68663          	beq	a3,a1,80003300 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800032b8:	2785                	addiw	a5,a5,1
    800032ba:	0711                	addi	a4,a4,4
    800032bc:	fef61be3          	bne	a2,a5,800032b2 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800032c0:	0621                	addi	a2,a2,8
    800032c2:	060a                	slli	a2,a2,0x2
    800032c4:	00017797          	auipc	a5,0x17
    800032c8:	1dc78793          	addi	a5,a5,476 # 8001a4a0 <log>
    800032cc:	97b2                	add	a5,a5,a2
    800032ce:	44d8                	lw	a4,12(s1)
    800032d0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032d2:	8526                	mv	a0,s1
    800032d4:	fcbfe0ef          	jal	8000229e <bpin>
    log.lh.n++;
    800032d8:	00017717          	auipc	a4,0x17
    800032dc:	1c870713          	addi	a4,a4,456 # 8001a4a0 <log>
    800032e0:	575c                	lw	a5,44(a4)
    800032e2:	2785                	addiw	a5,a5,1
    800032e4:	d75c                	sw	a5,44(a4)
    800032e6:	a80d                	j	80003318 <log_write+0xb8>
    panic("too big a transaction");
    800032e8:	00004517          	auipc	a0,0x4
    800032ec:	26850513          	addi	a0,a0,616 # 80007550 <etext+0x550>
    800032f0:	326020ef          	jal	80005616 <panic>
    panic("log_write outside of trans");
    800032f4:	00004517          	auipc	a0,0x4
    800032f8:	27450513          	addi	a0,a0,628 # 80007568 <etext+0x568>
    800032fc:	31a020ef          	jal	80005616 <panic>
  log.lh.block[i] = b->blockno;
    80003300:	00878693          	addi	a3,a5,8
    80003304:	068a                	slli	a3,a3,0x2
    80003306:	00017717          	auipc	a4,0x17
    8000330a:	19a70713          	addi	a4,a4,410 # 8001a4a0 <log>
    8000330e:	9736                	add	a4,a4,a3
    80003310:	44d4                	lw	a3,12(s1)
    80003312:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003314:	faf60fe3          	beq	a2,a5,800032d2 <log_write+0x72>
  }
  release(&log.lock);
    80003318:	00017517          	auipc	a0,0x17
    8000331c:	18850513          	addi	a0,a0,392 # 8001a4a0 <log>
    80003320:	6b8020ef          	jal	800059d8 <release>
}
    80003324:	60e2                	ld	ra,24(sp)
    80003326:	6442                	ld	s0,16(sp)
    80003328:	64a2                	ld	s1,8(sp)
    8000332a:	6902                	ld	s2,0(sp)
    8000332c:	6105                	addi	sp,sp,32
    8000332e:	8082                	ret

0000000080003330 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003330:	1101                	addi	sp,sp,-32
    80003332:	ec06                	sd	ra,24(sp)
    80003334:	e822                	sd	s0,16(sp)
    80003336:	e426                	sd	s1,8(sp)
    80003338:	e04a                	sd	s2,0(sp)
    8000333a:	1000                	addi	s0,sp,32
    8000333c:	84aa                	mv	s1,a0
    8000333e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003340:	00004597          	auipc	a1,0x4
    80003344:	24858593          	addi	a1,a1,584 # 80007588 <etext+0x588>
    80003348:	0521                	addi	a0,a0,8
    8000334a:	576020ef          	jal	800058c0 <initlock>
  lk->name = name;
    8000334e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003352:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003356:	0204a423          	sw	zero,40(s1)
}
    8000335a:	60e2                	ld	ra,24(sp)
    8000335c:	6442                	ld	s0,16(sp)
    8000335e:	64a2                	ld	s1,8(sp)
    80003360:	6902                	ld	s2,0(sp)
    80003362:	6105                	addi	sp,sp,32
    80003364:	8082                	ret

0000000080003366 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003366:	1101                	addi	sp,sp,-32
    80003368:	ec06                	sd	ra,24(sp)
    8000336a:	e822                	sd	s0,16(sp)
    8000336c:	e426                	sd	s1,8(sp)
    8000336e:	e04a                	sd	s2,0(sp)
    80003370:	1000                	addi	s0,sp,32
    80003372:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003374:	00850913          	addi	s2,a0,8
    80003378:	854a                	mv	a0,s2
    8000337a:	5ca020ef          	jal	80005944 <acquire>
  while (lk->locked) {
    8000337e:	409c                	lw	a5,0(s1)
    80003380:	c799                	beqz	a5,8000338e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003382:	85ca                	mv	a1,s2
    80003384:	8526                	mv	a0,s1
    80003386:	8a0fe0ef          	jal	80001426 <sleep>
  while (lk->locked) {
    8000338a:	409c                	lw	a5,0(s1)
    8000338c:	fbfd                	bnez	a5,80003382 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000338e:	4785                	li	a5,1
    80003390:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003392:	ac7fd0ef          	jal	80000e58 <myproc>
    80003396:	591c                	lw	a5,48(a0)
    80003398:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000339a:	854a                	mv	a0,s2
    8000339c:	63c020ef          	jal	800059d8 <release>
}
    800033a0:	60e2                	ld	ra,24(sp)
    800033a2:	6442                	ld	s0,16(sp)
    800033a4:	64a2                	ld	s1,8(sp)
    800033a6:	6902                	ld	s2,0(sp)
    800033a8:	6105                	addi	sp,sp,32
    800033aa:	8082                	ret

00000000800033ac <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800033ac:	1101                	addi	sp,sp,-32
    800033ae:	ec06                	sd	ra,24(sp)
    800033b0:	e822                	sd	s0,16(sp)
    800033b2:	e426                	sd	s1,8(sp)
    800033b4:	e04a                	sd	s2,0(sp)
    800033b6:	1000                	addi	s0,sp,32
    800033b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033ba:	00850913          	addi	s2,a0,8
    800033be:	854a                	mv	a0,s2
    800033c0:	584020ef          	jal	80005944 <acquire>
  lk->locked = 0;
    800033c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033c8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033cc:	8526                	mv	a0,s1
    800033ce:	8a4fe0ef          	jal	80001472 <wakeup>
  release(&lk->lk);
    800033d2:	854a                	mv	a0,s2
    800033d4:	604020ef          	jal	800059d8 <release>
}
    800033d8:	60e2                	ld	ra,24(sp)
    800033da:	6442                	ld	s0,16(sp)
    800033dc:	64a2                	ld	s1,8(sp)
    800033de:	6902                	ld	s2,0(sp)
    800033e0:	6105                	addi	sp,sp,32
    800033e2:	8082                	ret

00000000800033e4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033e4:	7179                	addi	sp,sp,-48
    800033e6:	f406                	sd	ra,40(sp)
    800033e8:	f022                	sd	s0,32(sp)
    800033ea:	ec26                	sd	s1,24(sp)
    800033ec:	e84a                	sd	s2,16(sp)
    800033ee:	1800                	addi	s0,sp,48
    800033f0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033f2:	00850913          	addi	s2,a0,8
    800033f6:	854a                	mv	a0,s2
    800033f8:	54c020ef          	jal	80005944 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033fc:	409c                	lw	a5,0(s1)
    800033fe:	ef81                	bnez	a5,80003416 <holdingsleep+0x32>
    80003400:	4481                	li	s1,0
  release(&lk->lk);
    80003402:	854a                	mv	a0,s2
    80003404:	5d4020ef          	jal	800059d8 <release>
  return r;
}
    80003408:	8526                	mv	a0,s1
    8000340a:	70a2                	ld	ra,40(sp)
    8000340c:	7402                	ld	s0,32(sp)
    8000340e:	64e2                	ld	s1,24(sp)
    80003410:	6942                	ld	s2,16(sp)
    80003412:	6145                	addi	sp,sp,48
    80003414:	8082                	ret
    80003416:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003418:	0284a983          	lw	s3,40(s1)
    8000341c:	a3dfd0ef          	jal	80000e58 <myproc>
    80003420:	5904                	lw	s1,48(a0)
    80003422:	413484b3          	sub	s1,s1,s3
    80003426:	0014b493          	seqz	s1,s1
    8000342a:	69a2                	ld	s3,8(sp)
    8000342c:	bfd9                	j	80003402 <holdingsleep+0x1e>

000000008000342e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000342e:	1141                	addi	sp,sp,-16
    80003430:	e406                	sd	ra,8(sp)
    80003432:	e022                	sd	s0,0(sp)
    80003434:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003436:	00004597          	auipc	a1,0x4
    8000343a:	16258593          	addi	a1,a1,354 # 80007598 <etext+0x598>
    8000343e:	00017517          	auipc	a0,0x17
    80003442:	1aa50513          	addi	a0,a0,426 # 8001a5e8 <ftable>
    80003446:	47a020ef          	jal	800058c0 <initlock>
}
    8000344a:	60a2                	ld	ra,8(sp)
    8000344c:	6402                	ld	s0,0(sp)
    8000344e:	0141                	addi	sp,sp,16
    80003450:	8082                	ret

0000000080003452 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003452:	1101                	addi	sp,sp,-32
    80003454:	ec06                	sd	ra,24(sp)
    80003456:	e822                	sd	s0,16(sp)
    80003458:	e426                	sd	s1,8(sp)
    8000345a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000345c:	00017517          	auipc	a0,0x17
    80003460:	18c50513          	addi	a0,a0,396 # 8001a5e8 <ftable>
    80003464:	4e0020ef          	jal	80005944 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003468:	00017497          	auipc	s1,0x17
    8000346c:	19848493          	addi	s1,s1,408 # 8001a600 <ftable+0x18>
    80003470:	00018717          	auipc	a4,0x18
    80003474:	13070713          	addi	a4,a4,304 # 8001b5a0 <disk>
    if(f->ref == 0){
    80003478:	40dc                	lw	a5,4(s1)
    8000347a:	cf89                	beqz	a5,80003494 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000347c:	02848493          	addi	s1,s1,40
    80003480:	fee49ce3          	bne	s1,a4,80003478 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003484:	00017517          	auipc	a0,0x17
    80003488:	16450513          	addi	a0,a0,356 # 8001a5e8 <ftable>
    8000348c:	54c020ef          	jal	800059d8 <release>
  return 0;
    80003490:	4481                	li	s1,0
    80003492:	a809                	j	800034a4 <filealloc+0x52>
      f->ref = 1;
    80003494:	4785                	li	a5,1
    80003496:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003498:	00017517          	auipc	a0,0x17
    8000349c:	15050513          	addi	a0,a0,336 # 8001a5e8 <ftable>
    800034a0:	538020ef          	jal	800059d8 <release>
}
    800034a4:	8526                	mv	a0,s1
    800034a6:	60e2                	ld	ra,24(sp)
    800034a8:	6442                	ld	s0,16(sp)
    800034aa:	64a2                	ld	s1,8(sp)
    800034ac:	6105                	addi	sp,sp,32
    800034ae:	8082                	ret

00000000800034b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800034b0:	1101                	addi	sp,sp,-32
    800034b2:	ec06                	sd	ra,24(sp)
    800034b4:	e822                	sd	s0,16(sp)
    800034b6:	e426                	sd	s1,8(sp)
    800034b8:	1000                	addi	s0,sp,32
    800034ba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800034bc:	00017517          	auipc	a0,0x17
    800034c0:	12c50513          	addi	a0,a0,300 # 8001a5e8 <ftable>
    800034c4:	480020ef          	jal	80005944 <acquire>
  if(f->ref < 1)
    800034c8:	40dc                	lw	a5,4(s1)
    800034ca:	02f05063          	blez	a5,800034ea <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034ce:	2785                	addiw	a5,a5,1
    800034d0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034d2:	00017517          	auipc	a0,0x17
    800034d6:	11650513          	addi	a0,a0,278 # 8001a5e8 <ftable>
    800034da:	4fe020ef          	jal	800059d8 <release>
  return f;
}
    800034de:	8526                	mv	a0,s1
    800034e0:	60e2                	ld	ra,24(sp)
    800034e2:	6442                	ld	s0,16(sp)
    800034e4:	64a2                	ld	s1,8(sp)
    800034e6:	6105                	addi	sp,sp,32
    800034e8:	8082                	ret
    panic("filedup");
    800034ea:	00004517          	auipc	a0,0x4
    800034ee:	0b650513          	addi	a0,a0,182 # 800075a0 <etext+0x5a0>
    800034f2:	124020ef          	jal	80005616 <panic>

00000000800034f6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034f6:	7139                	addi	sp,sp,-64
    800034f8:	fc06                	sd	ra,56(sp)
    800034fa:	f822                	sd	s0,48(sp)
    800034fc:	f426                	sd	s1,40(sp)
    800034fe:	0080                	addi	s0,sp,64
    80003500:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003502:	00017517          	auipc	a0,0x17
    80003506:	0e650513          	addi	a0,a0,230 # 8001a5e8 <ftable>
    8000350a:	43a020ef          	jal	80005944 <acquire>
  if(f->ref < 1)
    8000350e:	40dc                	lw	a5,4(s1)
    80003510:	04f05863          	blez	a5,80003560 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80003514:	37fd                	addiw	a5,a5,-1
    80003516:	c0dc                	sw	a5,4(s1)
    80003518:	04f04e63          	bgtz	a5,80003574 <fileclose+0x7e>
    8000351c:	f04a                	sd	s2,32(sp)
    8000351e:	ec4e                	sd	s3,24(sp)
    80003520:	e852                	sd	s4,16(sp)
    80003522:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003524:	0004a903          	lw	s2,0(s1)
    80003528:	0094ca83          	lbu	s5,9(s1)
    8000352c:	0104ba03          	ld	s4,16(s1)
    80003530:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003534:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003538:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000353c:	00017517          	auipc	a0,0x17
    80003540:	0ac50513          	addi	a0,a0,172 # 8001a5e8 <ftable>
    80003544:	494020ef          	jal	800059d8 <release>

  if(ff.type == FD_PIPE){
    80003548:	4785                	li	a5,1
    8000354a:	04f90063          	beq	s2,a5,8000358a <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000354e:	3979                	addiw	s2,s2,-2
    80003550:	4785                	li	a5,1
    80003552:	0527f563          	bgeu	a5,s2,8000359c <fileclose+0xa6>
    80003556:	7902                	ld	s2,32(sp)
    80003558:	69e2                	ld	s3,24(sp)
    8000355a:	6a42                	ld	s4,16(sp)
    8000355c:	6aa2                	ld	s5,8(sp)
    8000355e:	a00d                	j	80003580 <fileclose+0x8a>
    80003560:	f04a                	sd	s2,32(sp)
    80003562:	ec4e                	sd	s3,24(sp)
    80003564:	e852                	sd	s4,16(sp)
    80003566:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003568:	00004517          	auipc	a0,0x4
    8000356c:	04050513          	addi	a0,a0,64 # 800075a8 <etext+0x5a8>
    80003570:	0a6020ef          	jal	80005616 <panic>
    release(&ftable.lock);
    80003574:	00017517          	auipc	a0,0x17
    80003578:	07450513          	addi	a0,a0,116 # 8001a5e8 <ftable>
    8000357c:	45c020ef          	jal	800059d8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003580:	70e2                	ld	ra,56(sp)
    80003582:	7442                	ld	s0,48(sp)
    80003584:	74a2                	ld	s1,40(sp)
    80003586:	6121                	addi	sp,sp,64
    80003588:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000358a:	85d6                	mv	a1,s5
    8000358c:	8552                	mv	a0,s4
    8000358e:	340000ef          	jal	800038ce <pipeclose>
    80003592:	7902                	ld	s2,32(sp)
    80003594:	69e2                	ld	s3,24(sp)
    80003596:	6a42                	ld	s4,16(sp)
    80003598:	6aa2                	ld	s5,8(sp)
    8000359a:	b7dd                	j	80003580 <fileclose+0x8a>
    begin_op();
    8000359c:	b3bff0ef          	jal	800030d6 <begin_op>
    iput(ff.ip);
    800035a0:	854e                	mv	a0,s3
    800035a2:	c04ff0ef          	jal	800029a6 <iput>
    end_op();
    800035a6:	b9bff0ef          	jal	80003140 <end_op>
    800035aa:	7902                	ld	s2,32(sp)
    800035ac:	69e2                	ld	s3,24(sp)
    800035ae:	6a42                	ld	s4,16(sp)
    800035b0:	6aa2                	ld	s5,8(sp)
    800035b2:	b7f9                	j	80003580 <fileclose+0x8a>

00000000800035b4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800035b4:	715d                	addi	sp,sp,-80
    800035b6:	e486                	sd	ra,72(sp)
    800035b8:	e0a2                	sd	s0,64(sp)
    800035ba:	fc26                	sd	s1,56(sp)
    800035bc:	f44e                	sd	s3,40(sp)
    800035be:	0880                	addi	s0,sp,80
    800035c0:	84aa                	mv	s1,a0
    800035c2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800035c4:	895fd0ef          	jal	80000e58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035c8:	409c                	lw	a5,0(s1)
    800035ca:	37f9                	addiw	a5,a5,-2
    800035cc:	4705                	li	a4,1
    800035ce:	04f76263          	bltu	a4,a5,80003612 <filestat+0x5e>
    800035d2:	f84a                	sd	s2,48(sp)
    800035d4:	f052                	sd	s4,32(sp)
    800035d6:	892a                	mv	s2,a0
    ilock(f->ip);
    800035d8:	6c88                	ld	a0,24(s1)
    800035da:	a4aff0ef          	jal	80002824 <ilock>
    stati(f->ip, &st);
    800035de:	fb840a13          	addi	s4,s0,-72
    800035e2:	85d2                	mv	a1,s4
    800035e4:	6c88                	ld	a0,24(s1)
    800035e6:	c68ff0ef          	jal	80002a4e <stati>
    iunlock(f->ip);
    800035ea:	6c88                	ld	a0,24(s1)
    800035ec:	ae6ff0ef          	jal	800028d2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035f0:	46e1                	li	a3,24
    800035f2:	8652                	mv	a2,s4
    800035f4:	85ce                	mv	a1,s3
    800035f6:	05093503          	ld	a0,80(s2)
    800035fa:	c24fd0ef          	jal	80000a1e <copyout>
    800035fe:	41f5551b          	sraiw	a0,a0,0x1f
    80003602:	7942                	ld	s2,48(sp)
    80003604:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003606:	60a6                	ld	ra,72(sp)
    80003608:	6406                	ld	s0,64(sp)
    8000360a:	74e2                	ld	s1,56(sp)
    8000360c:	79a2                	ld	s3,40(sp)
    8000360e:	6161                	addi	sp,sp,80
    80003610:	8082                	ret
  return -1;
    80003612:	557d                	li	a0,-1
    80003614:	bfcd                	j	80003606 <filestat+0x52>

0000000080003616 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003616:	7179                	addi	sp,sp,-48
    80003618:	f406                	sd	ra,40(sp)
    8000361a:	f022                	sd	s0,32(sp)
    8000361c:	e84a                	sd	s2,16(sp)
    8000361e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003620:	00854783          	lbu	a5,8(a0)
    80003624:	cfd1                	beqz	a5,800036c0 <fileread+0xaa>
    80003626:	ec26                	sd	s1,24(sp)
    80003628:	e44e                	sd	s3,8(sp)
    8000362a:	84aa                	mv	s1,a0
    8000362c:	89ae                	mv	s3,a1
    8000362e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003630:	411c                	lw	a5,0(a0)
    80003632:	4705                	li	a4,1
    80003634:	04e78363          	beq	a5,a4,8000367a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003638:	470d                	li	a4,3
    8000363a:	04e78763          	beq	a5,a4,80003688 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000363e:	4709                	li	a4,2
    80003640:	06e79a63          	bne	a5,a4,800036b4 <fileread+0x9e>
    ilock(f->ip);
    80003644:	6d08                	ld	a0,24(a0)
    80003646:	9deff0ef          	jal	80002824 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000364a:	874a                	mv	a4,s2
    8000364c:	5094                	lw	a3,32(s1)
    8000364e:	864e                	mv	a2,s3
    80003650:	4585                	li	a1,1
    80003652:	6c88                	ld	a0,24(s1)
    80003654:	c28ff0ef          	jal	80002a7c <readi>
    80003658:	892a                	mv	s2,a0
    8000365a:	00a05563          	blez	a0,80003664 <fileread+0x4e>
      f->off += r;
    8000365e:	509c                	lw	a5,32(s1)
    80003660:	9fa9                	addw	a5,a5,a0
    80003662:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003664:	6c88                	ld	a0,24(s1)
    80003666:	a6cff0ef          	jal	800028d2 <iunlock>
    8000366a:	64e2                	ld	s1,24(sp)
    8000366c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000366e:	854a                	mv	a0,s2
    80003670:	70a2                	ld	ra,40(sp)
    80003672:	7402                	ld	s0,32(sp)
    80003674:	6942                	ld	s2,16(sp)
    80003676:	6145                	addi	sp,sp,48
    80003678:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000367a:	6908                	ld	a0,16(a0)
    8000367c:	3a2000ef          	jal	80003a1e <piperead>
    80003680:	892a                	mv	s2,a0
    80003682:	64e2                	ld	s1,24(sp)
    80003684:	69a2                	ld	s3,8(sp)
    80003686:	b7e5                	j	8000366e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003688:	02451783          	lh	a5,36(a0)
    8000368c:	03079693          	slli	a3,a5,0x30
    80003690:	92c1                	srli	a3,a3,0x30
    80003692:	4725                	li	a4,9
    80003694:	02d76863          	bltu	a4,a3,800036c4 <fileread+0xae>
    80003698:	0792                	slli	a5,a5,0x4
    8000369a:	00017717          	auipc	a4,0x17
    8000369e:	eae70713          	addi	a4,a4,-338 # 8001a548 <devsw>
    800036a2:	97ba                	add	a5,a5,a4
    800036a4:	639c                	ld	a5,0(a5)
    800036a6:	c39d                	beqz	a5,800036cc <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800036a8:	4505                	li	a0,1
    800036aa:	9782                	jalr	a5
    800036ac:	892a                	mv	s2,a0
    800036ae:	64e2                	ld	s1,24(sp)
    800036b0:	69a2                	ld	s3,8(sp)
    800036b2:	bf75                	j	8000366e <fileread+0x58>
    panic("fileread");
    800036b4:	00004517          	auipc	a0,0x4
    800036b8:	f0450513          	addi	a0,a0,-252 # 800075b8 <etext+0x5b8>
    800036bc:	75b010ef          	jal	80005616 <panic>
    return -1;
    800036c0:	597d                	li	s2,-1
    800036c2:	b775                	j	8000366e <fileread+0x58>
      return -1;
    800036c4:	597d                	li	s2,-1
    800036c6:	64e2                	ld	s1,24(sp)
    800036c8:	69a2                	ld	s3,8(sp)
    800036ca:	b755                	j	8000366e <fileread+0x58>
    800036cc:	597d                	li	s2,-1
    800036ce:	64e2                	ld	s1,24(sp)
    800036d0:	69a2                	ld	s3,8(sp)
    800036d2:	bf71                	j	8000366e <fileread+0x58>

00000000800036d4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036d4:	00954783          	lbu	a5,9(a0)
    800036d8:	10078e63          	beqz	a5,800037f4 <filewrite+0x120>
{
    800036dc:	711d                	addi	sp,sp,-96
    800036de:	ec86                	sd	ra,88(sp)
    800036e0:	e8a2                	sd	s0,80(sp)
    800036e2:	e0ca                	sd	s2,64(sp)
    800036e4:	f456                	sd	s5,40(sp)
    800036e6:	f05a                	sd	s6,32(sp)
    800036e8:	1080                	addi	s0,sp,96
    800036ea:	892a                	mv	s2,a0
    800036ec:	8b2e                	mv	s6,a1
    800036ee:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800036f0:	411c                	lw	a5,0(a0)
    800036f2:	4705                	li	a4,1
    800036f4:	02e78963          	beq	a5,a4,80003726 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036f8:	470d                	li	a4,3
    800036fa:	02e78a63          	beq	a5,a4,8000372e <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036fe:	4709                	li	a4,2
    80003700:	0ce79e63          	bne	a5,a4,800037dc <filewrite+0x108>
    80003704:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003706:	0ac05963          	blez	a2,800037b8 <filewrite+0xe4>
    8000370a:	e4a6                	sd	s1,72(sp)
    8000370c:	fc4e                	sd	s3,56(sp)
    8000370e:	ec5e                	sd	s7,24(sp)
    80003710:	e862                	sd	s8,16(sp)
    80003712:	e466                	sd	s9,8(sp)
    int i = 0;
    80003714:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003716:	6b85                	lui	s7,0x1
    80003718:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000371c:	6c85                	lui	s9,0x1
    8000371e:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003722:	4c05                	li	s8,1
    80003724:	a8ad                	j	8000379e <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003726:	6908                	ld	a0,16(a0)
    80003728:	1fe000ef          	jal	80003926 <pipewrite>
    8000372c:	a04d                	j	800037ce <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000372e:	02451783          	lh	a5,36(a0)
    80003732:	03079693          	slli	a3,a5,0x30
    80003736:	92c1                	srli	a3,a3,0x30
    80003738:	4725                	li	a4,9
    8000373a:	0ad76f63          	bltu	a4,a3,800037f8 <filewrite+0x124>
    8000373e:	0792                	slli	a5,a5,0x4
    80003740:	00017717          	auipc	a4,0x17
    80003744:	e0870713          	addi	a4,a4,-504 # 8001a548 <devsw>
    80003748:	97ba                	add	a5,a5,a4
    8000374a:	679c                	ld	a5,8(a5)
    8000374c:	cbc5                	beqz	a5,800037fc <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    8000374e:	4505                	li	a0,1
    80003750:	9782                	jalr	a5
    80003752:	a8b5                	j	800037ce <filewrite+0xfa>
      if(n1 > max)
    80003754:	2981                	sext.w	s3,s3
      begin_op();
    80003756:	981ff0ef          	jal	800030d6 <begin_op>
      ilock(f->ip);
    8000375a:	01893503          	ld	a0,24(s2)
    8000375e:	8c6ff0ef          	jal	80002824 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003762:	874e                	mv	a4,s3
    80003764:	02092683          	lw	a3,32(s2)
    80003768:	016a0633          	add	a2,s4,s6
    8000376c:	85e2                	mv	a1,s8
    8000376e:	01893503          	ld	a0,24(s2)
    80003772:	bfcff0ef          	jal	80002b6e <writei>
    80003776:	84aa                	mv	s1,a0
    80003778:	00a05763          	blez	a0,80003786 <filewrite+0xb2>
        f->off += r;
    8000377c:	02092783          	lw	a5,32(s2)
    80003780:	9fa9                	addw	a5,a5,a0
    80003782:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003786:	01893503          	ld	a0,24(s2)
    8000378a:	948ff0ef          	jal	800028d2 <iunlock>
      end_op();
    8000378e:	9b3ff0ef          	jal	80003140 <end_op>

      if(r != n1){
    80003792:	02999563          	bne	s3,s1,800037bc <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    80003796:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8000379a:	015a5963          	bge	s4,s5,800037ac <filewrite+0xd8>
      int n1 = n - i;
    8000379e:	414a87bb          	subw	a5,s5,s4
    800037a2:	89be                	mv	s3,a5
      if(n1 > max)
    800037a4:	fafbd8e3          	bge	s7,a5,80003754 <filewrite+0x80>
    800037a8:	89e6                	mv	s3,s9
    800037aa:	b76d                	j	80003754 <filewrite+0x80>
    800037ac:	64a6                	ld	s1,72(sp)
    800037ae:	79e2                	ld	s3,56(sp)
    800037b0:	6be2                	ld	s7,24(sp)
    800037b2:	6c42                	ld	s8,16(sp)
    800037b4:	6ca2                	ld	s9,8(sp)
    800037b6:	a801                	j	800037c6 <filewrite+0xf2>
    int i = 0;
    800037b8:	4a01                	li	s4,0
    800037ba:	a031                	j	800037c6 <filewrite+0xf2>
    800037bc:	64a6                	ld	s1,72(sp)
    800037be:	79e2                	ld	s3,56(sp)
    800037c0:	6be2                	ld	s7,24(sp)
    800037c2:	6c42                	ld	s8,16(sp)
    800037c4:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800037c6:	034a9d63          	bne	s5,s4,80003800 <filewrite+0x12c>
    800037ca:	8556                	mv	a0,s5
    800037cc:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037ce:	60e6                	ld	ra,88(sp)
    800037d0:	6446                	ld	s0,80(sp)
    800037d2:	6906                	ld	s2,64(sp)
    800037d4:	7aa2                	ld	s5,40(sp)
    800037d6:	7b02                	ld	s6,32(sp)
    800037d8:	6125                	addi	sp,sp,96
    800037da:	8082                	ret
    800037dc:	e4a6                	sd	s1,72(sp)
    800037de:	fc4e                	sd	s3,56(sp)
    800037e0:	f852                	sd	s4,48(sp)
    800037e2:	ec5e                	sd	s7,24(sp)
    800037e4:	e862                	sd	s8,16(sp)
    800037e6:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800037e8:	00004517          	auipc	a0,0x4
    800037ec:	de050513          	addi	a0,a0,-544 # 800075c8 <etext+0x5c8>
    800037f0:	627010ef          	jal	80005616 <panic>
    return -1;
    800037f4:	557d                	li	a0,-1
}
    800037f6:	8082                	ret
      return -1;
    800037f8:	557d                	li	a0,-1
    800037fa:	bfd1                	j	800037ce <filewrite+0xfa>
    800037fc:	557d                	li	a0,-1
    800037fe:	bfc1                	j	800037ce <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80003800:	557d                	li	a0,-1
    80003802:	7a42                	ld	s4,48(sp)
    80003804:	b7e9                	j	800037ce <filewrite+0xfa>

0000000080003806 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003806:	7179                	addi	sp,sp,-48
    80003808:	f406                	sd	ra,40(sp)
    8000380a:	f022                	sd	s0,32(sp)
    8000380c:	ec26                	sd	s1,24(sp)
    8000380e:	e052                	sd	s4,0(sp)
    80003810:	1800                	addi	s0,sp,48
    80003812:	84aa                	mv	s1,a0
    80003814:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003816:	0005b023          	sd	zero,0(a1)
    8000381a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000381e:	c35ff0ef          	jal	80003452 <filealloc>
    80003822:	e088                	sd	a0,0(s1)
    80003824:	c549                	beqz	a0,800038ae <pipealloc+0xa8>
    80003826:	c2dff0ef          	jal	80003452 <filealloc>
    8000382a:	00aa3023          	sd	a0,0(s4)
    8000382e:	cd25                	beqz	a0,800038a6 <pipealloc+0xa0>
    80003830:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003832:	8cdfc0ef          	jal	800000fe <kalloc>
    80003836:	892a                	mv	s2,a0
    80003838:	c12d                	beqz	a0,8000389a <pipealloc+0x94>
    8000383a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000383c:	4985                	li	s3,1
    8000383e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003842:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003846:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000384a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000384e:	00004597          	auipc	a1,0x4
    80003852:	d8a58593          	addi	a1,a1,-630 # 800075d8 <etext+0x5d8>
    80003856:	06a020ef          	jal	800058c0 <initlock>
  (*f0)->type = FD_PIPE;
    8000385a:	609c                	ld	a5,0(s1)
    8000385c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003860:	609c                	ld	a5,0(s1)
    80003862:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003866:	609c                	ld	a5,0(s1)
    80003868:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000386c:	609c                	ld	a5,0(s1)
    8000386e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003872:	000a3783          	ld	a5,0(s4)
    80003876:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000387a:	000a3783          	ld	a5,0(s4)
    8000387e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003882:	000a3783          	ld	a5,0(s4)
    80003886:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000388a:	000a3783          	ld	a5,0(s4)
    8000388e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003892:	4501                	li	a0,0
    80003894:	6942                	ld	s2,16(sp)
    80003896:	69a2                	ld	s3,8(sp)
    80003898:	a01d                	j	800038be <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000389a:	6088                	ld	a0,0(s1)
    8000389c:	c119                	beqz	a0,800038a2 <pipealloc+0x9c>
    8000389e:	6942                	ld	s2,16(sp)
    800038a0:	a029                	j	800038aa <pipealloc+0xa4>
    800038a2:	6942                	ld	s2,16(sp)
    800038a4:	a029                	j	800038ae <pipealloc+0xa8>
    800038a6:	6088                	ld	a0,0(s1)
    800038a8:	c10d                	beqz	a0,800038ca <pipealloc+0xc4>
    fileclose(*f0);
    800038aa:	c4dff0ef          	jal	800034f6 <fileclose>
  if(*f1)
    800038ae:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800038b2:	557d                	li	a0,-1
  if(*f1)
    800038b4:	c789                	beqz	a5,800038be <pipealloc+0xb8>
    fileclose(*f1);
    800038b6:	853e                	mv	a0,a5
    800038b8:	c3fff0ef          	jal	800034f6 <fileclose>
  return -1;
    800038bc:	557d                	li	a0,-1
}
    800038be:	70a2                	ld	ra,40(sp)
    800038c0:	7402                	ld	s0,32(sp)
    800038c2:	64e2                	ld	s1,24(sp)
    800038c4:	6a02                	ld	s4,0(sp)
    800038c6:	6145                	addi	sp,sp,48
    800038c8:	8082                	ret
  return -1;
    800038ca:	557d                	li	a0,-1
    800038cc:	bfcd                	j	800038be <pipealloc+0xb8>

00000000800038ce <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038ce:	1101                	addi	sp,sp,-32
    800038d0:	ec06                	sd	ra,24(sp)
    800038d2:	e822                	sd	s0,16(sp)
    800038d4:	e426                	sd	s1,8(sp)
    800038d6:	e04a                	sd	s2,0(sp)
    800038d8:	1000                	addi	s0,sp,32
    800038da:	84aa                	mv	s1,a0
    800038dc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038de:	066020ef          	jal	80005944 <acquire>
  if(writable){
    800038e2:	02090763          	beqz	s2,80003910 <pipeclose+0x42>
    pi->writeopen = 0;
    800038e6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038ea:	21848513          	addi	a0,s1,536
    800038ee:	b85fd0ef          	jal	80001472 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038f2:	2204b783          	ld	a5,544(s1)
    800038f6:	e785                	bnez	a5,8000391e <pipeclose+0x50>
    release(&pi->lock);
    800038f8:	8526                	mv	a0,s1
    800038fa:	0de020ef          	jal	800059d8 <release>
    kfree((char*)pi);
    800038fe:	8526                	mv	a0,s1
    80003900:	f1cfc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6902                	ld	s2,0(sp)
    8000390c:	6105                	addi	sp,sp,32
    8000390e:	8082                	ret
    pi->readopen = 0;
    80003910:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003914:	21c48513          	addi	a0,s1,540
    80003918:	b5bfd0ef          	jal	80001472 <wakeup>
    8000391c:	bfd9                	j	800038f2 <pipeclose+0x24>
    release(&pi->lock);
    8000391e:	8526                	mv	a0,s1
    80003920:	0b8020ef          	jal	800059d8 <release>
}
    80003924:	b7c5                	j	80003904 <pipeclose+0x36>

0000000080003926 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003926:	7159                	addi	sp,sp,-112
    80003928:	f486                	sd	ra,104(sp)
    8000392a:	f0a2                	sd	s0,96(sp)
    8000392c:	eca6                	sd	s1,88(sp)
    8000392e:	e8ca                	sd	s2,80(sp)
    80003930:	e4ce                	sd	s3,72(sp)
    80003932:	e0d2                	sd	s4,64(sp)
    80003934:	fc56                	sd	s5,56(sp)
    80003936:	1880                	addi	s0,sp,112
    80003938:	84aa                	mv	s1,a0
    8000393a:	8aae                	mv	s5,a1
    8000393c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000393e:	d1afd0ef          	jal	80000e58 <myproc>
    80003942:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003944:	8526                	mv	a0,s1
    80003946:	7ff010ef          	jal	80005944 <acquire>
  while(i < n){
    8000394a:	0d405263          	blez	s4,80003a0e <pipewrite+0xe8>
    8000394e:	f85a                	sd	s6,48(sp)
    80003950:	f45e                	sd	s7,40(sp)
    80003952:	f062                	sd	s8,32(sp)
    80003954:	ec66                	sd	s9,24(sp)
    80003956:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003958:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000395a:	f9f40c13          	addi	s8,s0,-97
    8000395e:	4b85                	li	s7,1
    80003960:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003962:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003966:	21c48c93          	addi	s9,s1,540
    8000396a:	a82d                	j	800039a4 <pipewrite+0x7e>
      release(&pi->lock);
    8000396c:	8526                	mv	a0,s1
    8000396e:	06a020ef          	jal	800059d8 <release>
      return -1;
    80003972:	597d                	li	s2,-1
    80003974:	7b42                	ld	s6,48(sp)
    80003976:	7ba2                	ld	s7,40(sp)
    80003978:	7c02                	ld	s8,32(sp)
    8000397a:	6ce2                	ld	s9,24(sp)
    8000397c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000397e:	854a                	mv	a0,s2
    80003980:	70a6                	ld	ra,104(sp)
    80003982:	7406                	ld	s0,96(sp)
    80003984:	64e6                	ld	s1,88(sp)
    80003986:	6946                	ld	s2,80(sp)
    80003988:	69a6                	ld	s3,72(sp)
    8000398a:	6a06                	ld	s4,64(sp)
    8000398c:	7ae2                	ld	s5,56(sp)
    8000398e:	6165                	addi	sp,sp,112
    80003990:	8082                	ret
      wakeup(&pi->nread);
    80003992:	856a                	mv	a0,s10
    80003994:	adffd0ef          	jal	80001472 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003998:	85a6                	mv	a1,s1
    8000399a:	8566                	mv	a0,s9
    8000399c:	a8bfd0ef          	jal	80001426 <sleep>
  while(i < n){
    800039a0:	05495a63          	bge	s2,s4,800039f4 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800039a4:	2204a783          	lw	a5,544(s1)
    800039a8:	d3f1                	beqz	a5,8000396c <pipewrite+0x46>
    800039aa:	854e                	mv	a0,s3
    800039ac:	cb3fd0ef          	jal	8000165e <killed>
    800039b0:	fd55                	bnez	a0,8000396c <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800039b2:	2184a783          	lw	a5,536(s1)
    800039b6:	21c4a703          	lw	a4,540(s1)
    800039ba:	2007879b          	addiw	a5,a5,512
    800039be:	fcf70ae3          	beq	a4,a5,80003992 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039c2:	86de                	mv	a3,s7
    800039c4:	01590633          	add	a2,s2,s5
    800039c8:	85e2                	mv	a1,s8
    800039ca:	0509b503          	ld	a0,80(s3)
    800039ce:	900fd0ef          	jal	80000ace <copyin>
    800039d2:	05650063          	beq	a0,s6,80003a12 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800039d6:	21c4a783          	lw	a5,540(s1)
    800039da:	0017871b          	addiw	a4,a5,1
    800039de:	20e4ae23          	sw	a4,540(s1)
    800039e2:	1ff7f793          	andi	a5,a5,511
    800039e6:	97a6                	add	a5,a5,s1
    800039e8:	f9f44703          	lbu	a4,-97(s0)
    800039ec:	00e78c23          	sb	a4,24(a5)
      i++;
    800039f0:	2905                	addiw	s2,s2,1
    800039f2:	b77d                	j	800039a0 <pipewrite+0x7a>
    800039f4:	7b42                	ld	s6,48(sp)
    800039f6:	7ba2                	ld	s7,40(sp)
    800039f8:	7c02                	ld	s8,32(sp)
    800039fa:	6ce2                	ld	s9,24(sp)
    800039fc:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800039fe:	21848513          	addi	a0,s1,536
    80003a02:	a71fd0ef          	jal	80001472 <wakeup>
  release(&pi->lock);
    80003a06:	8526                	mv	a0,s1
    80003a08:	7d1010ef          	jal	800059d8 <release>
  return i;
    80003a0c:	bf8d                	j	8000397e <pipewrite+0x58>
  int i = 0;
    80003a0e:	4901                	li	s2,0
    80003a10:	b7fd                	j	800039fe <pipewrite+0xd8>
    80003a12:	7b42                	ld	s6,48(sp)
    80003a14:	7ba2                	ld	s7,40(sp)
    80003a16:	7c02                	ld	s8,32(sp)
    80003a18:	6ce2                	ld	s9,24(sp)
    80003a1a:	6d42                	ld	s10,16(sp)
    80003a1c:	b7cd                	j	800039fe <pipewrite+0xd8>

0000000080003a1e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a1e:	711d                	addi	sp,sp,-96
    80003a20:	ec86                	sd	ra,88(sp)
    80003a22:	e8a2                	sd	s0,80(sp)
    80003a24:	e4a6                	sd	s1,72(sp)
    80003a26:	e0ca                	sd	s2,64(sp)
    80003a28:	fc4e                	sd	s3,56(sp)
    80003a2a:	f852                	sd	s4,48(sp)
    80003a2c:	f456                	sd	s5,40(sp)
    80003a2e:	1080                	addi	s0,sp,96
    80003a30:	84aa                	mv	s1,a0
    80003a32:	892e                	mv	s2,a1
    80003a34:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a36:	c22fd0ef          	jal	80000e58 <myproc>
    80003a3a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	707010ef          	jal	80005944 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a42:	2184a703          	lw	a4,536(s1)
    80003a46:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a4a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a4e:	02f71763          	bne	a4,a5,80003a7c <piperead+0x5e>
    80003a52:	2244a783          	lw	a5,548(s1)
    80003a56:	cf85                	beqz	a5,80003a8e <piperead+0x70>
    if(killed(pr)){
    80003a58:	8552                	mv	a0,s4
    80003a5a:	c05fd0ef          	jal	8000165e <killed>
    80003a5e:	e11d                	bnez	a0,80003a84 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a60:	85a6                	mv	a1,s1
    80003a62:	854e                	mv	a0,s3
    80003a64:	9c3fd0ef          	jal	80001426 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a68:	2184a703          	lw	a4,536(s1)
    80003a6c:	21c4a783          	lw	a5,540(s1)
    80003a70:	fef701e3          	beq	a4,a5,80003a52 <piperead+0x34>
    80003a74:	f05a                	sd	s6,32(sp)
    80003a76:	ec5e                	sd	s7,24(sp)
    80003a78:	e862                	sd	s8,16(sp)
    80003a7a:	a829                	j	80003a94 <piperead+0x76>
    80003a7c:	f05a                	sd	s6,32(sp)
    80003a7e:	ec5e                	sd	s7,24(sp)
    80003a80:	e862                	sd	s8,16(sp)
    80003a82:	a809                	j	80003a94 <piperead+0x76>
      release(&pi->lock);
    80003a84:	8526                	mv	a0,s1
    80003a86:	753010ef          	jal	800059d8 <release>
      return -1;
    80003a8a:	59fd                	li	s3,-1
    80003a8c:	a0a5                	j	80003af4 <piperead+0xd6>
    80003a8e:	f05a                	sd	s6,32(sp)
    80003a90:	ec5e                	sd	s7,24(sp)
    80003a92:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a94:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a96:	faf40c13          	addi	s8,s0,-81
    80003a9a:	4b85                	li	s7,1
    80003a9c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a9e:	05505163          	blez	s5,80003ae0 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80003aa2:	2184a783          	lw	a5,536(s1)
    80003aa6:	21c4a703          	lw	a4,540(s1)
    80003aaa:	02f70b63          	beq	a4,a5,80003ae0 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003aae:	0017871b          	addiw	a4,a5,1
    80003ab2:	20e4ac23          	sw	a4,536(s1)
    80003ab6:	1ff7f793          	andi	a5,a5,511
    80003aba:	97a6                	add	a5,a5,s1
    80003abc:	0187c783          	lbu	a5,24(a5)
    80003ac0:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ac4:	86de                	mv	a3,s7
    80003ac6:	8662                	mv	a2,s8
    80003ac8:	85ca                	mv	a1,s2
    80003aca:	050a3503          	ld	a0,80(s4)
    80003ace:	f51fc0ef          	jal	80000a1e <copyout>
    80003ad2:	01650763          	beq	a0,s6,80003ae0 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ad6:	2985                	addiw	s3,s3,1
    80003ad8:	0905                	addi	s2,s2,1
    80003ada:	fd3a94e3          	bne	s5,s3,80003aa2 <piperead+0x84>
    80003ade:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ae0:	21c48513          	addi	a0,s1,540
    80003ae4:	98ffd0ef          	jal	80001472 <wakeup>
  release(&pi->lock);
    80003ae8:	8526                	mv	a0,s1
    80003aea:	6ef010ef          	jal	800059d8 <release>
    80003aee:	7b02                	ld	s6,32(sp)
    80003af0:	6be2                	ld	s7,24(sp)
    80003af2:	6c42                	ld	s8,16(sp)
  return i;
}
    80003af4:	854e                	mv	a0,s3
    80003af6:	60e6                	ld	ra,88(sp)
    80003af8:	6446                	ld	s0,80(sp)
    80003afa:	64a6                	ld	s1,72(sp)
    80003afc:	6906                	ld	s2,64(sp)
    80003afe:	79e2                	ld	s3,56(sp)
    80003b00:	7a42                	ld	s4,48(sp)
    80003b02:	7aa2                	ld	s5,40(sp)
    80003b04:	6125                	addi	sp,sp,96
    80003b06:	8082                	ret

0000000080003b08 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003b08:	1141                	addi	sp,sp,-16
    80003b0a:	e406                	sd	ra,8(sp)
    80003b0c:	e022                	sd	s0,0(sp)
    80003b0e:	0800                	addi	s0,sp,16
    80003b10:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003b12:	0035151b          	slliw	a0,a0,0x3
    80003b16:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003b18:	8b89                	andi	a5,a5,2
    80003b1a:	c399                	beqz	a5,80003b20 <flags2perm+0x18>
      perm |= PTE_W;
    80003b1c:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b20:	60a2                	ld	ra,8(sp)
    80003b22:	6402                	ld	s0,0(sp)
    80003b24:	0141                	addi	sp,sp,16
    80003b26:	8082                	ret

0000000080003b28 <exec>:

int
exec(char *path, char **argv)
{
    80003b28:	de010113          	addi	sp,sp,-544
    80003b2c:	20113c23          	sd	ra,536(sp)
    80003b30:	20813823          	sd	s0,528(sp)
    80003b34:	20913423          	sd	s1,520(sp)
    80003b38:	21213023          	sd	s2,512(sp)
    80003b3c:	1400                	addi	s0,sp,544
    80003b3e:	892a                	mv	s2,a0
    80003b40:	dea43823          	sd	a0,-528(s0)
    80003b44:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b48:	b10fd0ef          	jal	80000e58 <myproc>
    80003b4c:	84aa                	mv	s1,a0

  begin_op();
    80003b4e:	d88ff0ef          	jal	800030d6 <begin_op>

  if((ip = namei(path)) == 0){
    80003b52:	854a                	mv	a0,s2
    80003b54:	bc0ff0ef          	jal	80002f14 <namei>
    80003b58:	cd21                	beqz	a0,80003bb0 <exec+0x88>
    80003b5a:	fbd2                	sd	s4,496(sp)
    80003b5c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b5e:	cc7fe0ef          	jal	80002824 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b62:	04000713          	li	a4,64
    80003b66:	4681                	li	a3,0
    80003b68:	e5040613          	addi	a2,s0,-432
    80003b6c:	4581                	li	a1,0
    80003b6e:	8552                	mv	a0,s4
    80003b70:	f0dfe0ef          	jal	80002a7c <readi>
    80003b74:	04000793          	li	a5,64
    80003b78:	00f51a63          	bne	a0,a5,80003b8c <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003b7c:	e5042703          	lw	a4,-432(s0)
    80003b80:	464c47b7          	lui	a5,0x464c4
    80003b84:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b88:	02f70863          	beq	a4,a5,80003bb8 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b8c:	8552                	mv	a0,s4
    80003b8e:	ea1fe0ef          	jal	80002a2e <iunlockput>
    end_op();
    80003b92:	daeff0ef          	jal	80003140 <end_op>
  }
  return -1;
    80003b96:	557d                	li	a0,-1
    80003b98:	7a5e                	ld	s4,496(sp)
}
    80003b9a:	21813083          	ld	ra,536(sp)
    80003b9e:	21013403          	ld	s0,528(sp)
    80003ba2:	20813483          	ld	s1,520(sp)
    80003ba6:	20013903          	ld	s2,512(sp)
    80003baa:	22010113          	addi	sp,sp,544
    80003bae:	8082                	ret
    end_op();
    80003bb0:	d90ff0ef          	jal	80003140 <end_op>
    return -1;
    80003bb4:	557d                	li	a0,-1
    80003bb6:	b7d5                	j	80003b9a <exec+0x72>
    80003bb8:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003bba:	8526                	mv	a0,s1
    80003bbc:	b44fd0ef          	jal	80000f00 <proc_pagetable>
    80003bc0:	8b2a                	mv	s6,a0
    80003bc2:	28050163          	beqz	a0,80003e44 <exec+0x31c>
    80003bc6:	ffce                	sd	s3,504(sp)
    80003bc8:	f7d6                	sd	s5,488(sp)
    80003bca:	efde                	sd	s7,472(sp)
    80003bcc:	ebe2                	sd	s8,464(sp)
    80003bce:	e7e6                	sd	s9,456(sp)
    80003bd0:	e3ea                	sd	s10,448(sp)
    80003bd2:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bd4:	e7042683          	lw	a3,-400(s0)
    80003bd8:	e8845783          	lhu	a5,-376(s0)
    80003bdc:	0e078763          	beqz	a5,80003cca <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003be0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003be2:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003be4:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003be8:	6c85                	lui	s9,0x1
    80003bea:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003bee:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003bf2:	6a85                	lui	s5,0x1
    80003bf4:	a085                	j	80003c54 <exec+0x12c>
      panic("loadseg: address should exist");
    80003bf6:	00004517          	auipc	a0,0x4
    80003bfa:	9ea50513          	addi	a0,a0,-1558 # 800075e0 <etext+0x5e0>
    80003bfe:	219010ef          	jal	80005616 <panic>
    if(sz - i < PGSIZE)
    80003c02:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003c04:	874a                	mv	a4,s2
    80003c06:	009c06bb          	addw	a3,s8,s1
    80003c0a:	4581                	li	a1,0
    80003c0c:	8552                	mv	a0,s4
    80003c0e:	e6ffe0ef          	jal	80002a7c <readi>
    80003c12:	22a91d63          	bne	s2,a0,80003e4c <exec+0x324>
  for(i = 0; i < sz; i += PGSIZE){
    80003c16:	009a84bb          	addw	s1,s5,s1
    80003c1a:	0334f263          	bgeu	s1,s3,80003c3e <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003c1e:	02049593          	slli	a1,s1,0x20
    80003c22:	9181                	srli	a1,a1,0x20
    80003c24:	95de                	add	a1,a1,s7
    80003c26:	855a                	mv	a0,s6
    80003c28:	85ffc0ef          	jal	80000486 <walkaddr>
    80003c2c:	862a                	mv	a2,a0
    if(pa == 0)
    80003c2e:	d561                	beqz	a0,80003bf6 <exec+0xce>
    if(sz - i < PGSIZE)
    80003c30:	409987bb          	subw	a5,s3,s1
    80003c34:	893e                	mv	s2,a5
    80003c36:	fcfcf6e3          	bgeu	s9,a5,80003c02 <exec+0xda>
    80003c3a:	8956                	mv	s2,s5
    80003c3c:	b7d9                	j	80003c02 <exec+0xda>
    sz = sz1;
    80003c3e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c42:	2d05                	addiw	s10,s10,1
    80003c44:	e0843783          	ld	a5,-504(s0)
    80003c48:	0387869b          	addiw	a3,a5,56
    80003c4c:	e8845783          	lhu	a5,-376(s0)
    80003c50:	06fd5e63          	bge	s10,a5,80003ccc <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c54:	e0d43423          	sd	a3,-504(s0)
    80003c58:	876e                	mv	a4,s11
    80003c5a:	e1840613          	addi	a2,s0,-488
    80003c5e:	4581                	li	a1,0
    80003c60:	8552                	mv	a0,s4
    80003c62:	e1bfe0ef          	jal	80002a7c <readi>
    80003c66:	1fb51163          	bne	a0,s11,80003e48 <exec+0x320>
    if(ph.type != ELF_PROG_LOAD)
    80003c6a:	e1842783          	lw	a5,-488(s0)
    80003c6e:	4705                	li	a4,1
    80003c70:	fce799e3          	bne	a5,a4,80003c42 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003c74:	e4043483          	ld	s1,-448(s0)
    80003c78:	e3843783          	ld	a5,-456(s0)
    80003c7c:	1ef4e663          	bltu	s1,a5,80003e68 <exec+0x340>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c80:	e2843783          	ld	a5,-472(s0)
    80003c84:	94be                	add	s1,s1,a5
    80003c86:	1ef4e463          	bltu	s1,a5,80003e6e <exec+0x346>
    if(ph.vaddr % PGSIZE != 0)
    80003c8a:	de843703          	ld	a4,-536(s0)
    80003c8e:	8ff9                	and	a5,a5,a4
    80003c90:	1e079263          	bnez	a5,80003e74 <exec+0x34c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c94:	e1c42503          	lw	a0,-484(s0)
    80003c98:	e71ff0ef          	jal	80003b08 <flags2perm>
    80003c9c:	86aa                	mv	a3,a0
    80003c9e:	8626                	mv	a2,s1
    80003ca0:	85ca                	mv	a1,s2
    80003ca2:	855a                	mv	a0,s6
    80003ca4:	b5bfc0ef          	jal	800007fe <uvmalloc>
    80003ca8:	dea43c23          	sd	a0,-520(s0)
    80003cac:	1c050763          	beqz	a0,80003e7a <exec+0x352>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003cb0:	e2843b83          	ld	s7,-472(s0)
    80003cb4:	e2042c03          	lw	s8,-480(s0)
    80003cb8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cbc:	00098463          	beqz	s3,80003cc4 <exec+0x19c>
    80003cc0:	4481                	li	s1,0
    80003cc2:	bfb1                	j	80003c1e <exec+0xf6>
    sz = sz1;
    80003cc4:	df843903          	ld	s2,-520(s0)
    80003cc8:	bfad                	j	80003c42 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cca:	4901                	li	s2,0
  iunlockput(ip);
    80003ccc:	8552                	mv	a0,s4
    80003cce:	d61fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    80003cd2:	c6eff0ef          	jal	80003140 <end_op>
  p = myproc();
    80003cd6:	982fd0ef          	jal	80000e58 <myproc>
    80003cda:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003cdc:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003ce0:	6985                	lui	s3,0x1
    80003ce2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003ce4:	99ca                	add	s3,s3,s2
    80003ce6:	77fd                	lui	a5,0xfffff
    80003ce8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003cec:	4691                	li	a3,4
    80003cee:	6609                	lui	a2,0x2
    80003cf0:	964e                	add	a2,a2,s3
    80003cf2:	85ce                	mv	a1,s3
    80003cf4:	855a                	mv	a0,s6
    80003cf6:	b09fc0ef          	jal	800007fe <uvmalloc>
    80003cfa:	8a2a                	mv	s4,a0
    80003cfc:	e105                	bnez	a0,80003d1c <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003cfe:	85ce                	mv	a1,s3
    80003d00:	855a                	mv	a0,s6
    80003d02:	a82fd0ef          	jal	80000f84 <proc_freepagetable>
  return -1;
    80003d06:	557d                	li	a0,-1
    80003d08:	79fe                	ld	s3,504(sp)
    80003d0a:	7a5e                	ld	s4,496(sp)
    80003d0c:	7abe                	ld	s5,488(sp)
    80003d0e:	7b1e                	ld	s6,480(sp)
    80003d10:	6bfe                	ld	s7,472(sp)
    80003d12:	6c5e                	ld	s8,464(sp)
    80003d14:	6cbe                	ld	s9,456(sp)
    80003d16:	6d1e                	ld	s10,448(sp)
    80003d18:	7dfa                	ld	s11,440(sp)
    80003d1a:	b541                	j	80003b9a <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d1c:	75f9                	lui	a1,0xffffe
    80003d1e:	95aa                	add	a1,a1,a0
    80003d20:	855a                	mv	a0,s6
    80003d22:	cd3fc0ef          	jal	800009f4 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d26:	7bfd                	lui	s7,0xfffff
    80003d28:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d2a:	e0043783          	ld	a5,-512(s0)
    80003d2e:	6388                	ld	a0,0(a5)
  sp = sz;
    80003d30:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d32:	4481                	li	s1,0
    ustack[argc] = sp;
    80003d34:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003d38:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003d3c:	cd21                	beqz	a0,80003d94 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003d3e:	d98fc0ef          	jal	800002d6 <strlen>
    80003d42:	0015079b          	addiw	a5,a0,1
    80003d46:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003d4a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003d4e:	13796963          	bltu	s2,s7,80003e80 <exec+0x358>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003d52:	e0043d83          	ld	s11,-512(s0)
    80003d56:	000db983          	ld	s3,0(s11)
    80003d5a:	854e                	mv	a0,s3
    80003d5c:	d7afc0ef          	jal	800002d6 <strlen>
    80003d60:	0015069b          	addiw	a3,a0,1
    80003d64:	864e                	mv	a2,s3
    80003d66:	85ca                	mv	a1,s2
    80003d68:	855a                	mv	a0,s6
    80003d6a:	cb5fc0ef          	jal	80000a1e <copyout>
    80003d6e:	10054b63          	bltz	a0,80003e84 <exec+0x35c>
    ustack[argc] = sp;
    80003d72:	00349793          	slli	a5,s1,0x3
    80003d76:	97e6                	add	a5,a5,s9
    80003d78:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb820>
  for(argc = 0; argv[argc]; argc++) {
    80003d7c:	0485                	addi	s1,s1,1
    80003d7e:	008d8793          	addi	a5,s11,8
    80003d82:	e0f43023          	sd	a5,-512(s0)
    80003d86:	008db503          	ld	a0,8(s11)
    80003d8a:	c509                	beqz	a0,80003d94 <exec+0x26c>
    if(argc >= MAXARG)
    80003d8c:	fb8499e3          	bne	s1,s8,80003d3e <exec+0x216>
  sz = sz1;
    80003d90:	89d2                	mv	s3,s4
    80003d92:	b7b5                	j	80003cfe <exec+0x1d6>
  ustack[argc] = 0;
    80003d94:	00349793          	slli	a5,s1,0x3
    80003d98:	f9078793          	addi	a5,a5,-112
    80003d9c:	97a2                	add	a5,a5,s0
    80003d9e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003da2:	00148693          	addi	a3,s1,1
    80003da6:	068e                	slli	a3,a3,0x3
    80003da8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003dac:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003db0:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003db2:	f57966e3          	bltu	s2,s7,80003cfe <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003db6:	e9040613          	addi	a2,s0,-368
    80003dba:	85ca                	mv	a1,s2
    80003dbc:	855a                	mv	a0,s6
    80003dbe:	c61fc0ef          	jal	80000a1e <copyout>
    80003dc2:	f2054ee3          	bltz	a0,80003cfe <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003dc6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003dca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003dce:	df043783          	ld	a5,-528(s0)
    80003dd2:	0007c703          	lbu	a4,0(a5)
    80003dd6:	cf11                	beqz	a4,80003df2 <exec+0x2ca>
    80003dd8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003dda:	02f00693          	li	a3,47
    80003dde:	a029                	j	80003de8 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003de0:	0785                	addi	a5,a5,1
    80003de2:	fff7c703          	lbu	a4,-1(a5)
    80003de6:	c711                	beqz	a4,80003df2 <exec+0x2ca>
    if(*s == '/')
    80003de8:	fed71ce3          	bne	a4,a3,80003de0 <exec+0x2b8>
      last = s+1;
    80003dec:	def43823          	sd	a5,-528(s0)
    80003df0:	bfc5                	j	80003de0 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003df2:	4641                	li	a2,16
    80003df4:	df043583          	ld	a1,-528(s0)
    80003df8:	158a8513          	addi	a0,s5,344
    80003dfc:	ca4fc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003e00:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003e04:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003e08:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003e0c:	058ab783          	ld	a5,88(s5)
    80003e10:	e6843703          	ld	a4,-408(s0)
    80003e14:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e16:	058ab783          	ld	a5,88(s5)
    80003e1a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e1e:	85ea                	mv	a1,s10
    80003e20:	964fd0ef          	jal	80000f84 <proc_freepagetable>
  vmprint(p->pagetable);  // Print the process's page table
    80003e24:	050ab503          	ld	a0,80(s5)
    80003e28:	e71fc0ef          	jal	80000c98 <vmprint>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e2c:	0004851b          	sext.w	a0,s1
    80003e30:	79fe                	ld	s3,504(sp)
    80003e32:	7a5e                	ld	s4,496(sp)
    80003e34:	7abe                	ld	s5,488(sp)
    80003e36:	7b1e                	ld	s6,480(sp)
    80003e38:	6bfe                	ld	s7,472(sp)
    80003e3a:	6c5e                	ld	s8,464(sp)
    80003e3c:	6cbe                	ld	s9,456(sp)
    80003e3e:	6d1e                	ld	s10,448(sp)
    80003e40:	7dfa                	ld	s11,440(sp)
    80003e42:	bba1                	j	80003b9a <exec+0x72>
    80003e44:	7b1e                	ld	s6,480(sp)
    80003e46:	b399                	j	80003b8c <exec+0x64>
    80003e48:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003e4c:	df843583          	ld	a1,-520(s0)
    80003e50:	855a                	mv	a0,s6
    80003e52:	932fd0ef          	jal	80000f84 <proc_freepagetable>
  if(ip){
    80003e56:	79fe                	ld	s3,504(sp)
    80003e58:	7abe                	ld	s5,488(sp)
    80003e5a:	7b1e                	ld	s6,480(sp)
    80003e5c:	6bfe                	ld	s7,472(sp)
    80003e5e:	6c5e                	ld	s8,464(sp)
    80003e60:	6cbe                	ld	s9,456(sp)
    80003e62:	6d1e                	ld	s10,448(sp)
    80003e64:	7dfa                	ld	s11,440(sp)
    80003e66:	b31d                	j	80003b8c <exec+0x64>
    80003e68:	df243c23          	sd	s2,-520(s0)
    80003e6c:	b7c5                	j	80003e4c <exec+0x324>
    80003e6e:	df243c23          	sd	s2,-520(s0)
    80003e72:	bfe9                	j	80003e4c <exec+0x324>
    80003e74:	df243c23          	sd	s2,-520(s0)
    80003e78:	bfd1                	j	80003e4c <exec+0x324>
    80003e7a:	df243c23          	sd	s2,-520(s0)
    80003e7e:	b7f9                	j	80003e4c <exec+0x324>
  sz = sz1;
    80003e80:	89d2                	mv	s3,s4
    80003e82:	bdb5                	j	80003cfe <exec+0x1d6>
    80003e84:	89d2                	mv	s3,s4
    80003e86:	bda5                	j	80003cfe <exec+0x1d6>

0000000080003e88 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e88:	7179                	addi	sp,sp,-48
    80003e8a:	f406                	sd	ra,40(sp)
    80003e8c:	f022                	sd	s0,32(sp)
    80003e8e:	ec26                	sd	s1,24(sp)
    80003e90:	e84a                	sd	s2,16(sp)
    80003e92:	1800                	addi	s0,sp,48
    80003e94:	892e                	mv	s2,a1
    80003e96:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e98:	fdc40593          	addi	a1,s0,-36
    80003e9c:	e6ffd0ef          	jal	80001d0a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003ea0:	fdc42703          	lw	a4,-36(s0)
    80003ea4:	47bd                	li	a5,15
    80003ea6:	02e7e963          	bltu	a5,a4,80003ed8 <argfd+0x50>
    80003eaa:	faffc0ef          	jal	80000e58 <myproc>
    80003eae:	fdc42703          	lw	a4,-36(s0)
    80003eb2:	01a70793          	addi	a5,a4,26
    80003eb6:	078e                	slli	a5,a5,0x3
    80003eb8:	953e                	add	a0,a0,a5
    80003eba:	611c                	ld	a5,0(a0)
    80003ebc:	c385                	beqz	a5,80003edc <argfd+0x54>
    return -1;
  if(pfd)
    80003ebe:	00090463          	beqz	s2,80003ec6 <argfd+0x3e>
    *pfd = fd;
    80003ec2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003ec6:	4501                	li	a0,0
  if(pf)
    80003ec8:	c091                	beqz	s1,80003ecc <argfd+0x44>
    *pf = f;
    80003eca:	e09c                	sd	a5,0(s1)
}
    80003ecc:	70a2                	ld	ra,40(sp)
    80003ece:	7402                	ld	s0,32(sp)
    80003ed0:	64e2                	ld	s1,24(sp)
    80003ed2:	6942                	ld	s2,16(sp)
    80003ed4:	6145                	addi	sp,sp,48
    80003ed6:	8082                	ret
    return -1;
    80003ed8:	557d                	li	a0,-1
    80003eda:	bfcd                	j	80003ecc <argfd+0x44>
    80003edc:	557d                	li	a0,-1
    80003ede:	b7fd                	j	80003ecc <argfd+0x44>

0000000080003ee0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003ee0:	1101                	addi	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	e426                	sd	s1,8(sp)
    80003ee8:	1000                	addi	s0,sp,32
    80003eea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003eec:	f6dfc0ef          	jal	80000e58 <myproc>
    80003ef0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003ef2:	0d050793          	addi	a5,a0,208
    80003ef6:	4501                	li	a0,0
    80003ef8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003efa:	6398                	ld	a4,0(a5)
    80003efc:	cb19                	beqz	a4,80003f12 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003efe:	2505                	addiw	a0,a0,1
    80003f00:	07a1                	addi	a5,a5,8
    80003f02:	fed51ce3          	bne	a0,a3,80003efa <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003f06:	557d                	li	a0,-1
}
    80003f08:	60e2                	ld	ra,24(sp)
    80003f0a:	6442                	ld	s0,16(sp)
    80003f0c:	64a2                	ld	s1,8(sp)
    80003f0e:	6105                	addi	sp,sp,32
    80003f10:	8082                	ret
      p->ofile[fd] = f;
    80003f12:	01a50793          	addi	a5,a0,26
    80003f16:	078e                	slli	a5,a5,0x3
    80003f18:	963e                	add	a2,a2,a5
    80003f1a:	e204                	sd	s1,0(a2)
      return fd;
    80003f1c:	b7f5                	j	80003f08 <fdalloc+0x28>

0000000080003f1e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003f1e:	715d                	addi	sp,sp,-80
    80003f20:	e486                	sd	ra,72(sp)
    80003f22:	e0a2                	sd	s0,64(sp)
    80003f24:	fc26                	sd	s1,56(sp)
    80003f26:	f84a                	sd	s2,48(sp)
    80003f28:	f44e                	sd	s3,40(sp)
    80003f2a:	ec56                	sd	s5,24(sp)
    80003f2c:	e85a                	sd	s6,16(sp)
    80003f2e:	0880                	addi	s0,sp,80
    80003f30:	8b2e                	mv	s6,a1
    80003f32:	89b2                	mv	s3,a2
    80003f34:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f36:	fb040593          	addi	a1,s0,-80
    80003f3a:	ff5fe0ef          	jal	80002f2e <nameiparent>
    80003f3e:	84aa                	mv	s1,a0
    80003f40:	10050a63          	beqz	a0,80004054 <create+0x136>
    return 0;

  ilock(dp);
    80003f44:	8e1fe0ef          	jal	80002824 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f48:	4601                	li	a2,0
    80003f4a:	fb040593          	addi	a1,s0,-80
    80003f4e:	8526                	mv	a0,s1
    80003f50:	d39fe0ef          	jal	80002c88 <dirlookup>
    80003f54:	8aaa                	mv	s5,a0
    80003f56:	c129                	beqz	a0,80003f98 <create+0x7a>
    iunlockput(dp);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	ad5fe0ef          	jal	80002a2e <iunlockput>
    ilock(ip);
    80003f5e:	8556                	mv	a0,s5
    80003f60:	8c5fe0ef          	jal	80002824 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f64:	4789                	li	a5,2
    80003f66:	02fb1463          	bne	s6,a5,80003f8e <create+0x70>
    80003f6a:	044ad783          	lhu	a5,68(s5)
    80003f6e:	37f9                	addiw	a5,a5,-2
    80003f70:	17c2                	slli	a5,a5,0x30
    80003f72:	93c1                	srli	a5,a5,0x30
    80003f74:	4705                	li	a4,1
    80003f76:	00f76c63          	bltu	a4,a5,80003f8e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f7a:	8556                	mv	a0,s5
    80003f7c:	60a6                	ld	ra,72(sp)
    80003f7e:	6406                	ld	s0,64(sp)
    80003f80:	74e2                	ld	s1,56(sp)
    80003f82:	7942                	ld	s2,48(sp)
    80003f84:	79a2                	ld	s3,40(sp)
    80003f86:	6ae2                	ld	s5,24(sp)
    80003f88:	6b42                	ld	s6,16(sp)
    80003f8a:	6161                	addi	sp,sp,80
    80003f8c:	8082                	ret
    iunlockput(ip);
    80003f8e:	8556                	mv	a0,s5
    80003f90:	a9ffe0ef          	jal	80002a2e <iunlockput>
    return 0;
    80003f94:	4a81                	li	s5,0
    80003f96:	b7d5                	j	80003f7a <create+0x5c>
    80003f98:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f9a:	85da                	mv	a1,s6
    80003f9c:	4088                	lw	a0,0(s1)
    80003f9e:	f16fe0ef          	jal	800026b4 <ialloc>
    80003fa2:	8a2a                	mv	s4,a0
    80003fa4:	cd15                	beqz	a0,80003fe0 <create+0xc2>
  ilock(ip);
    80003fa6:	87ffe0ef          	jal	80002824 <ilock>
  ip->major = major;
    80003faa:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003fae:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003fb2:	4905                	li	s2,1
    80003fb4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003fb8:	8552                	mv	a0,s4
    80003fba:	fb6fe0ef          	jal	80002770 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003fbe:	032b0763          	beq	s6,s2,80003fec <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fc2:	004a2603          	lw	a2,4(s4)
    80003fc6:	fb040593          	addi	a1,s0,-80
    80003fca:	8526                	mv	a0,s1
    80003fcc:	e9ffe0ef          	jal	80002e6a <dirlink>
    80003fd0:	06054563          	bltz	a0,8000403a <create+0x11c>
  iunlockput(dp);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	a59fe0ef          	jal	80002a2e <iunlockput>
  return ip;
    80003fda:	8ad2                	mv	s5,s4
    80003fdc:	7a02                	ld	s4,32(sp)
    80003fde:	bf71                	j	80003f7a <create+0x5c>
    iunlockput(dp);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	a4dfe0ef          	jal	80002a2e <iunlockput>
    return 0;
    80003fe6:	8ad2                	mv	s5,s4
    80003fe8:	7a02                	ld	s4,32(sp)
    80003fea:	bf41                	j	80003f7a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fec:	004a2603          	lw	a2,4(s4)
    80003ff0:	00003597          	auipc	a1,0x3
    80003ff4:	61058593          	addi	a1,a1,1552 # 80007600 <etext+0x600>
    80003ff8:	8552                	mv	a0,s4
    80003ffa:	e71fe0ef          	jal	80002e6a <dirlink>
    80003ffe:	02054e63          	bltz	a0,8000403a <create+0x11c>
    80004002:	40d0                	lw	a2,4(s1)
    80004004:	00003597          	auipc	a1,0x3
    80004008:	60458593          	addi	a1,a1,1540 # 80007608 <etext+0x608>
    8000400c:	8552                	mv	a0,s4
    8000400e:	e5dfe0ef          	jal	80002e6a <dirlink>
    80004012:	02054463          	bltz	a0,8000403a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004016:	004a2603          	lw	a2,4(s4)
    8000401a:	fb040593          	addi	a1,s0,-80
    8000401e:	8526                	mv	a0,s1
    80004020:	e4bfe0ef          	jal	80002e6a <dirlink>
    80004024:	00054b63          	bltz	a0,8000403a <create+0x11c>
    dp->nlink++;  // for ".."
    80004028:	04a4d783          	lhu	a5,74(s1)
    8000402c:	2785                	addiw	a5,a5,1
    8000402e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004032:	8526                	mv	a0,s1
    80004034:	f3cfe0ef          	jal	80002770 <iupdate>
    80004038:	bf71                	j	80003fd4 <create+0xb6>
  ip->nlink = 0;
    8000403a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000403e:	8552                	mv	a0,s4
    80004040:	f30fe0ef          	jal	80002770 <iupdate>
  iunlockput(ip);
    80004044:	8552                	mv	a0,s4
    80004046:	9e9fe0ef          	jal	80002a2e <iunlockput>
  iunlockput(dp);
    8000404a:	8526                	mv	a0,s1
    8000404c:	9e3fe0ef          	jal	80002a2e <iunlockput>
  return 0;
    80004050:	7a02                	ld	s4,32(sp)
    80004052:	b725                	j	80003f7a <create+0x5c>
    return 0;
    80004054:	8aaa                	mv	s5,a0
    80004056:	b715                	j	80003f7a <create+0x5c>

0000000080004058 <sys_dup>:
{
    80004058:	7179                	addi	sp,sp,-48
    8000405a:	f406                	sd	ra,40(sp)
    8000405c:	f022                	sd	s0,32(sp)
    8000405e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004060:	fd840613          	addi	a2,s0,-40
    80004064:	4581                	li	a1,0
    80004066:	4501                	li	a0,0
    80004068:	e21ff0ef          	jal	80003e88 <argfd>
    return -1;
    8000406c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000406e:	02054363          	bltz	a0,80004094 <sys_dup+0x3c>
    80004072:	ec26                	sd	s1,24(sp)
    80004074:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004076:	fd843903          	ld	s2,-40(s0)
    8000407a:	854a                	mv	a0,s2
    8000407c:	e65ff0ef          	jal	80003ee0 <fdalloc>
    80004080:	84aa                	mv	s1,a0
    return -1;
    80004082:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004084:	00054d63          	bltz	a0,8000409e <sys_dup+0x46>
  filedup(f);
    80004088:	854a                	mv	a0,s2
    8000408a:	c26ff0ef          	jal	800034b0 <filedup>
  return fd;
    8000408e:	87a6                	mv	a5,s1
    80004090:	64e2                	ld	s1,24(sp)
    80004092:	6942                	ld	s2,16(sp)
}
    80004094:	853e                	mv	a0,a5
    80004096:	70a2                	ld	ra,40(sp)
    80004098:	7402                	ld	s0,32(sp)
    8000409a:	6145                	addi	sp,sp,48
    8000409c:	8082                	ret
    8000409e:	64e2                	ld	s1,24(sp)
    800040a0:	6942                	ld	s2,16(sp)
    800040a2:	bfcd                	j	80004094 <sys_dup+0x3c>

00000000800040a4 <sys_read>:
{
    800040a4:	7179                	addi	sp,sp,-48
    800040a6:	f406                	sd	ra,40(sp)
    800040a8:	f022                	sd	s0,32(sp)
    800040aa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040ac:	fd840593          	addi	a1,s0,-40
    800040b0:	4505                	li	a0,1
    800040b2:	c75fd0ef          	jal	80001d26 <argaddr>
  argint(2, &n);
    800040b6:	fe440593          	addi	a1,s0,-28
    800040ba:	4509                	li	a0,2
    800040bc:	c4ffd0ef          	jal	80001d0a <argint>
  if(argfd(0, 0, &f) < 0)
    800040c0:	fe840613          	addi	a2,s0,-24
    800040c4:	4581                	li	a1,0
    800040c6:	4501                	li	a0,0
    800040c8:	dc1ff0ef          	jal	80003e88 <argfd>
    800040cc:	87aa                	mv	a5,a0
    return -1;
    800040ce:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040d0:	0007ca63          	bltz	a5,800040e4 <sys_read+0x40>
  return fileread(f, p, n);
    800040d4:	fe442603          	lw	a2,-28(s0)
    800040d8:	fd843583          	ld	a1,-40(s0)
    800040dc:	fe843503          	ld	a0,-24(s0)
    800040e0:	d36ff0ef          	jal	80003616 <fileread>
}
    800040e4:	70a2                	ld	ra,40(sp)
    800040e6:	7402                	ld	s0,32(sp)
    800040e8:	6145                	addi	sp,sp,48
    800040ea:	8082                	ret

00000000800040ec <sys_write>:
{
    800040ec:	7179                	addi	sp,sp,-48
    800040ee:	f406                	sd	ra,40(sp)
    800040f0:	f022                	sd	s0,32(sp)
    800040f2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040f4:	fd840593          	addi	a1,s0,-40
    800040f8:	4505                	li	a0,1
    800040fa:	c2dfd0ef          	jal	80001d26 <argaddr>
  argint(2, &n);
    800040fe:	fe440593          	addi	a1,s0,-28
    80004102:	4509                	li	a0,2
    80004104:	c07fd0ef          	jal	80001d0a <argint>
  if(argfd(0, 0, &f) < 0)
    80004108:	fe840613          	addi	a2,s0,-24
    8000410c:	4581                	li	a1,0
    8000410e:	4501                	li	a0,0
    80004110:	d79ff0ef          	jal	80003e88 <argfd>
    80004114:	87aa                	mv	a5,a0
    return -1;
    80004116:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004118:	0007ca63          	bltz	a5,8000412c <sys_write+0x40>
  return filewrite(f, p, n);
    8000411c:	fe442603          	lw	a2,-28(s0)
    80004120:	fd843583          	ld	a1,-40(s0)
    80004124:	fe843503          	ld	a0,-24(s0)
    80004128:	dacff0ef          	jal	800036d4 <filewrite>
}
    8000412c:	70a2                	ld	ra,40(sp)
    8000412e:	7402                	ld	s0,32(sp)
    80004130:	6145                	addi	sp,sp,48
    80004132:	8082                	ret

0000000080004134 <sys_close>:
{
    80004134:	1101                	addi	sp,sp,-32
    80004136:	ec06                	sd	ra,24(sp)
    80004138:	e822                	sd	s0,16(sp)
    8000413a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000413c:	fe040613          	addi	a2,s0,-32
    80004140:	fec40593          	addi	a1,s0,-20
    80004144:	4501                	li	a0,0
    80004146:	d43ff0ef          	jal	80003e88 <argfd>
    return -1;
    8000414a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000414c:	02054063          	bltz	a0,8000416c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004150:	d09fc0ef          	jal	80000e58 <myproc>
    80004154:	fec42783          	lw	a5,-20(s0)
    80004158:	07e9                	addi	a5,a5,26
    8000415a:	078e                	slli	a5,a5,0x3
    8000415c:	953e                	add	a0,a0,a5
    8000415e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004162:	fe043503          	ld	a0,-32(s0)
    80004166:	b90ff0ef          	jal	800034f6 <fileclose>
  return 0;
    8000416a:	4781                	li	a5,0
}
    8000416c:	853e                	mv	a0,a5
    8000416e:	60e2                	ld	ra,24(sp)
    80004170:	6442                	ld	s0,16(sp)
    80004172:	6105                	addi	sp,sp,32
    80004174:	8082                	ret

0000000080004176 <sys_fstat>:
{
    80004176:	1101                	addi	sp,sp,-32
    80004178:	ec06                	sd	ra,24(sp)
    8000417a:	e822                	sd	s0,16(sp)
    8000417c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000417e:	fe040593          	addi	a1,s0,-32
    80004182:	4505                	li	a0,1
    80004184:	ba3fd0ef          	jal	80001d26 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004188:	fe840613          	addi	a2,s0,-24
    8000418c:	4581                	li	a1,0
    8000418e:	4501                	li	a0,0
    80004190:	cf9ff0ef          	jal	80003e88 <argfd>
    80004194:	87aa                	mv	a5,a0
    return -1;
    80004196:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004198:	0007c863          	bltz	a5,800041a8 <sys_fstat+0x32>
  return filestat(f, st);
    8000419c:	fe043583          	ld	a1,-32(s0)
    800041a0:	fe843503          	ld	a0,-24(s0)
    800041a4:	c10ff0ef          	jal	800035b4 <filestat>
}
    800041a8:	60e2                	ld	ra,24(sp)
    800041aa:	6442                	ld	s0,16(sp)
    800041ac:	6105                	addi	sp,sp,32
    800041ae:	8082                	ret

00000000800041b0 <sys_link>:
{
    800041b0:	7169                	addi	sp,sp,-304
    800041b2:	f606                	sd	ra,296(sp)
    800041b4:	f222                	sd	s0,288(sp)
    800041b6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041b8:	08000613          	li	a2,128
    800041bc:	ed040593          	addi	a1,s0,-304
    800041c0:	4501                	li	a0,0
    800041c2:	b81fd0ef          	jal	80001d42 <argstr>
    return -1;
    800041c6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041c8:	0c054e63          	bltz	a0,800042a4 <sys_link+0xf4>
    800041cc:	08000613          	li	a2,128
    800041d0:	f5040593          	addi	a1,s0,-176
    800041d4:	4505                	li	a0,1
    800041d6:	b6dfd0ef          	jal	80001d42 <argstr>
    return -1;
    800041da:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041dc:	0c054463          	bltz	a0,800042a4 <sys_link+0xf4>
    800041e0:	ee26                	sd	s1,280(sp)
  begin_op();
    800041e2:	ef5fe0ef          	jal	800030d6 <begin_op>
  if((ip = namei(old)) == 0){
    800041e6:	ed040513          	addi	a0,s0,-304
    800041ea:	d2bfe0ef          	jal	80002f14 <namei>
    800041ee:	84aa                	mv	s1,a0
    800041f0:	c53d                	beqz	a0,8000425e <sys_link+0xae>
  ilock(ip);
    800041f2:	e32fe0ef          	jal	80002824 <ilock>
  if(ip->type == T_DIR){
    800041f6:	04449703          	lh	a4,68(s1)
    800041fa:	4785                	li	a5,1
    800041fc:	06f70663          	beq	a4,a5,80004268 <sys_link+0xb8>
    80004200:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004202:	04a4d783          	lhu	a5,74(s1)
    80004206:	2785                	addiw	a5,a5,1
    80004208:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000420c:	8526                	mv	a0,s1
    8000420e:	d62fe0ef          	jal	80002770 <iupdate>
  iunlock(ip);
    80004212:	8526                	mv	a0,s1
    80004214:	ebefe0ef          	jal	800028d2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004218:	fd040593          	addi	a1,s0,-48
    8000421c:	f5040513          	addi	a0,s0,-176
    80004220:	d0ffe0ef          	jal	80002f2e <nameiparent>
    80004224:	892a                	mv	s2,a0
    80004226:	cd21                	beqz	a0,8000427e <sys_link+0xce>
  ilock(dp);
    80004228:	dfcfe0ef          	jal	80002824 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000422c:	00092703          	lw	a4,0(s2)
    80004230:	409c                	lw	a5,0(s1)
    80004232:	04f71363          	bne	a4,a5,80004278 <sys_link+0xc8>
    80004236:	40d0                	lw	a2,4(s1)
    80004238:	fd040593          	addi	a1,s0,-48
    8000423c:	854a                	mv	a0,s2
    8000423e:	c2dfe0ef          	jal	80002e6a <dirlink>
    80004242:	02054b63          	bltz	a0,80004278 <sys_link+0xc8>
  iunlockput(dp);
    80004246:	854a                	mv	a0,s2
    80004248:	fe6fe0ef          	jal	80002a2e <iunlockput>
  iput(ip);
    8000424c:	8526                	mv	a0,s1
    8000424e:	f58fe0ef          	jal	800029a6 <iput>
  end_op();
    80004252:	eeffe0ef          	jal	80003140 <end_op>
  return 0;
    80004256:	4781                	li	a5,0
    80004258:	64f2                	ld	s1,280(sp)
    8000425a:	6952                	ld	s2,272(sp)
    8000425c:	a0a1                	j	800042a4 <sys_link+0xf4>
    end_op();
    8000425e:	ee3fe0ef          	jal	80003140 <end_op>
    return -1;
    80004262:	57fd                	li	a5,-1
    80004264:	64f2                	ld	s1,280(sp)
    80004266:	a83d                	j	800042a4 <sys_link+0xf4>
    iunlockput(ip);
    80004268:	8526                	mv	a0,s1
    8000426a:	fc4fe0ef          	jal	80002a2e <iunlockput>
    end_op();
    8000426e:	ed3fe0ef          	jal	80003140 <end_op>
    return -1;
    80004272:	57fd                	li	a5,-1
    80004274:	64f2                	ld	s1,280(sp)
    80004276:	a03d                	j	800042a4 <sys_link+0xf4>
    iunlockput(dp);
    80004278:	854a                	mv	a0,s2
    8000427a:	fb4fe0ef          	jal	80002a2e <iunlockput>
  ilock(ip);
    8000427e:	8526                	mv	a0,s1
    80004280:	da4fe0ef          	jal	80002824 <ilock>
  ip->nlink--;
    80004284:	04a4d783          	lhu	a5,74(s1)
    80004288:	37fd                	addiw	a5,a5,-1
    8000428a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000428e:	8526                	mv	a0,s1
    80004290:	ce0fe0ef          	jal	80002770 <iupdate>
  iunlockput(ip);
    80004294:	8526                	mv	a0,s1
    80004296:	f98fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    8000429a:	ea7fe0ef          	jal	80003140 <end_op>
  return -1;
    8000429e:	57fd                	li	a5,-1
    800042a0:	64f2                	ld	s1,280(sp)
    800042a2:	6952                	ld	s2,272(sp)
}
    800042a4:	853e                	mv	a0,a5
    800042a6:	70b2                	ld	ra,296(sp)
    800042a8:	7412                	ld	s0,288(sp)
    800042aa:	6155                	addi	sp,sp,304
    800042ac:	8082                	ret

00000000800042ae <sys_unlink>:
{
    800042ae:	7111                	addi	sp,sp,-256
    800042b0:	fd86                	sd	ra,248(sp)
    800042b2:	f9a2                	sd	s0,240(sp)
    800042b4:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800042b6:	08000613          	li	a2,128
    800042ba:	f2040593          	addi	a1,s0,-224
    800042be:	4501                	li	a0,0
    800042c0:	a83fd0ef          	jal	80001d42 <argstr>
    800042c4:	16054663          	bltz	a0,80004430 <sys_unlink+0x182>
    800042c8:	f5a6                	sd	s1,232(sp)
  begin_op();
    800042ca:	e0dfe0ef          	jal	800030d6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800042ce:	fa040593          	addi	a1,s0,-96
    800042d2:	f2040513          	addi	a0,s0,-224
    800042d6:	c59fe0ef          	jal	80002f2e <nameiparent>
    800042da:	84aa                	mv	s1,a0
    800042dc:	c955                	beqz	a0,80004390 <sys_unlink+0xe2>
  ilock(dp);
    800042de:	d46fe0ef          	jal	80002824 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800042e2:	00003597          	auipc	a1,0x3
    800042e6:	31e58593          	addi	a1,a1,798 # 80007600 <etext+0x600>
    800042ea:	fa040513          	addi	a0,s0,-96
    800042ee:	985fe0ef          	jal	80002c72 <namecmp>
    800042f2:	12050463          	beqz	a0,8000441a <sys_unlink+0x16c>
    800042f6:	00003597          	auipc	a1,0x3
    800042fa:	31258593          	addi	a1,a1,786 # 80007608 <etext+0x608>
    800042fe:	fa040513          	addi	a0,s0,-96
    80004302:	971fe0ef          	jal	80002c72 <namecmp>
    80004306:	10050a63          	beqz	a0,8000441a <sys_unlink+0x16c>
    8000430a:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000430c:	f1c40613          	addi	a2,s0,-228
    80004310:	fa040593          	addi	a1,s0,-96
    80004314:	8526                	mv	a0,s1
    80004316:	973fe0ef          	jal	80002c88 <dirlookup>
    8000431a:	892a                	mv	s2,a0
    8000431c:	0e050e63          	beqz	a0,80004418 <sys_unlink+0x16a>
    80004320:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004322:	d02fe0ef          	jal	80002824 <ilock>
  if(ip->nlink < 1)
    80004326:	04a91783          	lh	a5,74(s2)
    8000432a:	06f05863          	blez	a5,8000439a <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000432e:	04491703          	lh	a4,68(s2)
    80004332:	4785                	li	a5,1
    80004334:	06f70b63          	beq	a4,a5,800043aa <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004338:	fb040993          	addi	s3,s0,-80
    8000433c:	4641                	li	a2,16
    8000433e:	4581                	li	a1,0
    80004340:	854e                	mv	a0,s3
    80004342:	e0dfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004346:	4741                	li	a4,16
    80004348:	f1c42683          	lw	a3,-228(s0)
    8000434c:	864e                	mv	a2,s3
    8000434e:	4581                	li	a1,0
    80004350:	8526                	mv	a0,s1
    80004352:	81dfe0ef          	jal	80002b6e <writei>
    80004356:	47c1                	li	a5,16
    80004358:	08f51f63          	bne	a0,a5,800043f6 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000435c:	04491703          	lh	a4,68(s2)
    80004360:	4785                	li	a5,1
    80004362:	0af70263          	beq	a4,a5,80004406 <sys_unlink+0x158>
  iunlockput(dp);
    80004366:	8526                	mv	a0,s1
    80004368:	ec6fe0ef          	jal	80002a2e <iunlockput>
  ip->nlink--;
    8000436c:	04a95783          	lhu	a5,74(s2)
    80004370:	37fd                	addiw	a5,a5,-1
    80004372:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004376:	854a                	mv	a0,s2
    80004378:	bf8fe0ef          	jal	80002770 <iupdate>
  iunlockput(ip);
    8000437c:	854a                	mv	a0,s2
    8000437e:	eb0fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    80004382:	dbffe0ef          	jal	80003140 <end_op>
  return 0;
    80004386:	4501                	li	a0,0
    80004388:	74ae                	ld	s1,232(sp)
    8000438a:	790e                	ld	s2,224(sp)
    8000438c:	69ee                	ld	s3,216(sp)
    8000438e:	a869                	j	80004428 <sys_unlink+0x17a>
    end_op();
    80004390:	db1fe0ef          	jal	80003140 <end_op>
    return -1;
    80004394:	557d                	li	a0,-1
    80004396:	74ae                	ld	s1,232(sp)
    80004398:	a841                	j	80004428 <sys_unlink+0x17a>
    8000439a:	e9d2                	sd	s4,208(sp)
    8000439c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000439e:	00003517          	auipc	a0,0x3
    800043a2:	27250513          	addi	a0,a0,626 # 80007610 <etext+0x610>
    800043a6:	270010ef          	jal	80005616 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043aa:	04c92703          	lw	a4,76(s2)
    800043ae:	02000793          	li	a5,32
    800043b2:	f8e7f3e3          	bgeu	a5,a4,80004338 <sys_unlink+0x8a>
    800043b6:	e9d2                	sd	s4,208(sp)
    800043b8:	e5d6                	sd	s5,200(sp)
    800043ba:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043bc:	f0840a93          	addi	s5,s0,-248
    800043c0:	4a41                	li	s4,16
    800043c2:	8752                	mv	a4,s4
    800043c4:	86ce                	mv	a3,s3
    800043c6:	8656                	mv	a2,s5
    800043c8:	4581                	li	a1,0
    800043ca:	854a                	mv	a0,s2
    800043cc:	eb0fe0ef          	jal	80002a7c <readi>
    800043d0:	01451d63          	bne	a0,s4,800043ea <sys_unlink+0x13c>
    if(de.inum != 0)
    800043d4:	f0845783          	lhu	a5,-248(s0)
    800043d8:	efb1                	bnez	a5,80004434 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043da:	29c1                	addiw	s3,s3,16
    800043dc:	04c92783          	lw	a5,76(s2)
    800043e0:	fef9e1e3          	bltu	s3,a5,800043c2 <sys_unlink+0x114>
    800043e4:	6a4e                	ld	s4,208(sp)
    800043e6:	6aae                	ld	s5,200(sp)
    800043e8:	bf81                	j	80004338 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800043ea:	00003517          	auipc	a0,0x3
    800043ee:	23e50513          	addi	a0,a0,574 # 80007628 <etext+0x628>
    800043f2:	224010ef          	jal	80005616 <panic>
    800043f6:	e9d2                	sd	s4,208(sp)
    800043f8:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800043fa:	00003517          	auipc	a0,0x3
    800043fe:	24650513          	addi	a0,a0,582 # 80007640 <etext+0x640>
    80004402:	214010ef          	jal	80005616 <panic>
    dp->nlink--;
    80004406:	04a4d783          	lhu	a5,74(s1)
    8000440a:	37fd                	addiw	a5,a5,-1
    8000440c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004410:	8526                	mv	a0,s1
    80004412:	b5efe0ef          	jal	80002770 <iupdate>
    80004416:	bf81                	j	80004366 <sys_unlink+0xb8>
    80004418:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    8000441a:	8526                	mv	a0,s1
    8000441c:	e12fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    80004420:	d21fe0ef          	jal	80003140 <end_op>
  return -1;
    80004424:	557d                	li	a0,-1
    80004426:	74ae                	ld	s1,232(sp)
}
    80004428:	70ee                	ld	ra,248(sp)
    8000442a:	744e                	ld	s0,240(sp)
    8000442c:	6111                	addi	sp,sp,256
    8000442e:	8082                	ret
    return -1;
    80004430:	557d                	li	a0,-1
    80004432:	bfdd                	j	80004428 <sys_unlink+0x17a>
    iunlockput(ip);
    80004434:	854a                	mv	a0,s2
    80004436:	df8fe0ef          	jal	80002a2e <iunlockput>
    goto bad;
    8000443a:	790e                	ld	s2,224(sp)
    8000443c:	69ee                	ld	s3,216(sp)
    8000443e:	6a4e                	ld	s4,208(sp)
    80004440:	6aae                	ld	s5,200(sp)
    80004442:	bfe1                	j	8000441a <sys_unlink+0x16c>

0000000080004444 <sys_open>:

uint64
sys_open(void)
{
    80004444:	7131                	addi	sp,sp,-192
    80004446:	fd06                	sd	ra,184(sp)
    80004448:	f922                	sd	s0,176(sp)
    8000444a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000444c:	f4c40593          	addi	a1,s0,-180
    80004450:	4505                	li	a0,1
    80004452:	8b9fd0ef          	jal	80001d0a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004456:	08000613          	li	a2,128
    8000445a:	f5040593          	addi	a1,s0,-176
    8000445e:	4501                	li	a0,0
    80004460:	8e3fd0ef          	jal	80001d42 <argstr>
    80004464:	87aa                	mv	a5,a0
    return -1;
    80004466:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004468:	0a07c363          	bltz	a5,8000450e <sys_open+0xca>
    8000446c:	f526                	sd	s1,168(sp)

  begin_op();
    8000446e:	c69fe0ef          	jal	800030d6 <begin_op>

  if(omode & O_CREATE){
    80004472:	f4c42783          	lw	a5,-180(s0)
    80004476:	2007f793          	andi	a5,a5,512
    8000447a:	c3dd                	beqz	a5,80004520 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000447c:	4681                	li	a3,0
    8000447e:	4601                	li	a2,0
    80004480:	4589                	li	a1,2
    80004482:	f5040513          	addi	a0,s0,-176
    80004486:	a99ff0ef          	jal	80003f1e <create>
    8000448a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000448c:	c549                	beqz	a0,80004516 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000448e:	04449703          	lh	a4,68(s1)
    80004492:	478d                	li	a5,3
    80004494:	00f71763          	bne	a4,a5,800044a2 <sys_open+0x5e>
    80004498:	0464d703          	lhu	a4,70(s1)
    8000449c:	47a5                	li	a5,9
    8000449e:	0ae7ee63          	bltu	a5,a4,8000455a <sys_open+0x116>
    800044a2:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800044a4:	faffe0ef          	jal	80003452 <filealloc>
    800044a8:	892a                	mv	s2,a0
    800044aa:	c561                	beqz	a0,80004572 <sys_open+0x12e>
    800044ac:	ed4e                	sd	s3,152(sp)
    800044ae:	a33ff0ef          	jal	80003ee0 <fdalloc>
    800044b2:	89aa                	mv	s3,a0
    800044b4:	0a054b63          	bltz	a0,8000456a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800044b8:	04449703          	lh	a4,68(s1)
    800044bc:	478d                	li	a5,3
    800044be:	0cf70363          	beq	a4,a5,80004584 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800044c2:	4789                	li	a5,2
    800044c4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800044c8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800044cc:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800044d0:	f4c42783          	lw	a5,-180(s0)
    800044d4:	0017f713          	andi	a4,a5,1
    800044d8:	00174713          	xori	a4,a4,1
    800044dc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800044e0:	0037f713          	andi	a4,a5,3
    800044e4:	00e03733          	snez	a4,a4
    800044e8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800044ec:	4007f793          	andi	a5,a5,1024
    800044f0:	c791                	beqz	a5,800044fc <sys_open+0xb8>
    800044f2:	04449703          	lh	a4,68(s1)
    800044f6:	4789                	li	a5,2
    800044f8:	08f70d63          	beq	a4,a5,80004592 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800044fc:	8526                	mv	a0,s1
    800044fe:	bd4fe0ef          	jal	800028d2 <iunlock>
  end_op();
    80004502:	c3ffe0ef          	jal	80003140 <end_op>

  return fd;
    80004506:	854e                	mv	a0,s3
    80004508:	74aa                	ld	s1,168(sp)
    8000450a:	790a                	ld	s2,160(sp)
    8000450c:	69ea                	ld	s3,152(sp)
}
    8000450e:	70ea                	ld	ra,184(sp)
    80004510:	744a                	ld	s0,176(sp)
    80004512:	6129                	addi	sp,sp,192
    80004514:	8082                	ret
      end_op();
    80004516:	c2bfe0ef          	jal	80003140 <end_op>
      return -1;
    8000451a:	557d                	li	a0,-1
    8000451c:	74aa                	ld	s1,168(sp)
    8000451e:	bfc5                	j	8000450e <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004520:	f5040513          	addi	a0,s0,-176
    80004524:	9f1fe0ef          	jal	80002f14 <namei>
    80004528:	84aa                	mv	s1,a0
    8000452a:	c11d                	beqz	a0,80004550 <sys_open+0x10c>
    ilock(ip);
    8000452c:	af8fe0ef          	jal	80002824 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004530:	04449703          	lh	a4,68(s1)
    80004534:	4785                	li	a5,1
    80004536:	f4f71ce3          	bne	a4,a5,8000448e <sys_open+0x4a>
    8000453a:	f4c42783          	lw	a5,-180(s0)
    8000453e:	d3b5                	beqz	a5,800044a2 <sys_open+0x5e>
      iunlockput(ip);
    80004540:	8526                	mv	a0,s1
    80004542:	cecfe0ef          	jal	80002a2e <iunlockput>
      end_op();
    80004546:	bfbfe0ef          	jal	80003140 <end_op>
      return -1;
    8000454a:	557d                	li	a0,-1
    8000454c:	74aa                	ld	s1,168(sp)
    8000454e:	b7c1                	j	8000450e <sys_open+0xca>
      end_op();
    80004550:	bf1fe0ef          	jal	80003140 <end_op>
      return -1;
    80004554:	557d                	li	a0,-1
    80004556:	74aa                	ld	s1,168(sp)
    80004558:	bf5d                	j	8000450e <sys_open+0xca>
    iunlockput(ip);
    8000455a:	8526                	mv	a0,s1
    8000455c:	cd2fe0ef          	jal	80002a2e <iunlockput>
    end_op();
    80004560:	be1fe0ef          	jal	80003140 <end_op>
    return -1;
    80004564:	557d                	li	a0,-1
    80004566:	74aa                	ld	s1,168(sp)
    80004568:	b75d                	j	8000450e <sys_open+0xca>
      fileclose(f);
    8000456a:	854a                	mv	a0,s2
    8000456c:	f8bfe0ef          	jal	800034f6 <fileclose>
    80004570:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004572:	8526                	mv	a0,s1
    80004574:	cbafe0ef          	jal	80002a2e <iunlockput>
    end_op();
    80004578:	bc9fe0ef          	jal	80003140 <end_op>
    return -1;
    8000457c:	557d                	li	a0,-1
    8000457e:	74aa                	ld	s1,168(sp)
    80004580:	790a                	ld	s2,160(sp)
    80004582:	b771                	j	8000450e <sys_open+0xca>
    f->type = FD_DEVICE;
    80004584:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004588:	04649783          	lh	a5,70(s1)
    8000458c:	02f91223          	sh	a5,36(s2)
    80004590:	bf35                	j	800044cc <sys_open+0x88>
    itrunc(ip);
    80004592:	8526                	mv	a0,s1
    80004594:	b7efe0ef          	jal	80002912 <itrunc>
    80004598:	b795                	j	800044fc <sys_open+0xb8>

000000008000459a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000459a:	7175                	addi	sp,sp,-144
    8000459c:	e506                	sd	ra,136(sp)
    8000459e:	e122                	sd	s0,128(sp)
    800045a0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800045a2:	b35fe0ef          	jal	800030d6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800045a6:	08000613          	li	a2,128
    800045aa:	f7040593          	addi	a1,s0,-144
    800045ae:	4501                	li	a0,0
    800045b0:	f92fd0ef          	jal	80001d42 <argstr>
    800045b4:	02054363          	bltz	a0,800045da <sys_mkdir+0x40>
    800045b8:	4681                	li	a3,0
    800045ba:	4601                	li	a2,0
    800045bc:	4585                	li	a1,1
    800045be:	f7040513          	addi	a0,s0,-144
    800045c2:	95dff0ef          	jal	80003f1e <create>
    800045c6:	c911                	beqz	a0,800045da <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045c8:	c66fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    800045cc:	b75fe0ef          	jal	80003140 <end_op>
  return 0;
    800045d0:	4501                	li	a0,0
}
    800045d2:	60aa                	ld	ra,136(sp)
    800045d4:	640a                	ld	s0,128(sp)
    800045d6:	6149                	addi	sp,sp,144
    800045d8:	8082                	ret
    end_op();
    800045da:	b67fe0ef          	jal	80003140 <end_op>
    return -1;
    800045de:	557d                	li	a0,-1
    800045e0:	bfcd                	j	800045d2 <sys_mkdir+0x38>

00000000800045e2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800045e2:	7135                	addi	sp,sp,-160
    800045e4:	ed06                	sd	ra,152(sp)
    800045e6:	e922                	sd	s0,144(sp)
    800045e8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800045ea:	aedfe0ef          	jal	800030d6 <begin_op>
  argint(1, &major);
    800045ee:	f6c40593          	addi	a1,s0,-148
    800045f2:	4505                	li	a0,1
    800045f4:	f16fd0ef          	jal	80001d0a <argint>
  argint(2, &minor);
    800045f8:	f6840593          	addi	a1,s0,-152
    800045fc:	4509                	li	a0,2
    800045fe:	f0cfd0ef          	jal	80001d0a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004602:	08000613          	li	a2,128
    80004606:	f7040593          	addi	a1,s0,-144
    8000460a:	4501                	li	a0,0
    8000460c:	f36fd0ef          	jal	80001d42 <argstr>
    80004610:	02054563          	bltz	a0,8000463a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004614:	f6841683          	lh	a3,-152(s0)
    80004618:	f6c41603          	lh	a2,-148(s0)
    8000461c:	458d                	li	a1,3
    8000461e:	f7040513          	addi	a0,s0,-144
    80004622:	8fdff0ef          	jal	80003f1e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004626:	c911                	beqz	a0,8000463a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004628:	c06fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    8000462c:	b15fe0ef          	jal	80003140 <end_op>
  return 0;
    80004630:	4501                	li	a0,0
}
    80004632:	60ea                	ld	ra,152(sp)
    80004634:	644a                	ld	s0,144(sp)
    80004636:	610d                	addi	sp,sp,160
    80004638:	8082                	ret
    end_op();
    8000463a:	b07fe0ef          	jal	80003140 <end_op>
    return -1;
    8000463e:	557d                	li	a0,-1
    80004640:	bfcd                	j	80004632 <sys_mknod+0x50>

0000000080004642 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004642:	7135                	addi	sp,sp,-160
    80004644:	ed06                	sd	ra,152(sp)
    80004646:	e922                	sd	s0,144(sp)
    80004648:	e14a                	sd	s2,128(sp)
    8000464a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000464c:	80dfc0ef          	jal	80000e58 <myproc>
    80004650:	892a                	mv	s2,a0
  
  begin_op();
    80004652:	a85fe0ef          	jal	800030d6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004656:	08000613          	li	a2,128
    8000465a:	f6040593          	addi	a1,s0,-160
    8000465e:	4501                	li	a0,0
    80004660:	ee2fd0ef          	jal	80001d42 <argstr>
    80004664:	04054363          	bltz	a0,800046aa <sys_chdir+0x68>
    80004668:	e526                	sd	s1,136(sp)
    8000466a:	f6040513          	addi	a0,s0,-160
    8000466e:	8a7fe0ef          	jal	80002f14 <namei>
    80004672:	84aa                	mv	s1,a0
    80004674:	c915                	beqz	a0,800046a8 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004676:	9aefe0ef          	jal	80002824 <ilock>
  if(ip->type != T_DIR){
    8000467a:	04449703          	lh	a4,68(s1)
    8000467e:	4785                	li	a5,1
    80004680:	02f71963          	bne	a4,a5,800046b2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004684:	8526                	mv	a0,s1
    80004686:	a4cfe0ef          	jal	800028d2 <iunlock>
  iput(p->cwd);
    8000468a:	15093503          	ld	a0,336(s2)
    8000468e:	b18fe0ef          	jal	800029a6 <iput>
  end_op();
    80004692:	aaffe0ef          	jal	80003140 <end_op>
  p->cwd = ip;
    80004696:	14993823          	sd	s1,336(s2)
  return 0;
    8000469a:	4501                	li	a0,0
    8000469c:	64aa                	ld	s1,136(sp)
}
    8000469e:	60ea                	ld	ra,152(sp)
    800046a0:	644a                	ld	s0,144(sp)
    800046a2:	690a                	ld	s2,128(sp)
    800046a4:	610d                	addi	sp,sp,160
    800046a6:	8082                	ret
    800046a8:	64aa                	ld	s1,136(sp)
    end_op();
    800046aa:	a97fe0ef          	jal	80003140 <end_op>
    return -1;
    800046ae:	557d                	li	a0,-1
    800046b0:	b7fd                	j	8000469e <sys_chdir+0x5c>
    iunlockput(ip);
    800046b2:	8526                	mv	a0,s1
    800046b4:	b7afe0ef          	jal	80002a2e <iunlockput>
    end_op();
    800046b8:	a89fe0ef          	jal	80003140 <end_op>
    return -1;
    800046bc:	557d                	li	a0,-1
    800046be:	64aa                	ld	s1,136(sp)
    800046c0:	bff9                	j	8000469e <sys_chdir+0x5c>

00000000800046c2 <sys_exec>:

uint64
sys_exec(void)
{
    800046c2:	7105                	addi	sp,sp,-480
    800046c4:	ef86                	sd	ra,472(sp)
    800046c6:	eba2                	sd	s0,464(sp)
    800046c8:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800046ca:	e2840593          	addi	a1,s0,-472
    800046ce:	4505                	li	a0,1
    800046d0:	e56fd0ef          	jal	80001d26 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800046d4:	08000613          	li	a2,128
    800046d8:	f3040593          	addi	a1,s0,-208
    800046dc:	4501                	li	a0,0
    800046de:	e64fd0ef          	jal	80001d42 <argstr>
    800046e2:	87aa                	mv	a5,a0
    return -1;
    800046e4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800046e6:	0e07c063          	bltz	a5,800047c6 <sys_exec+0x104>
    800046ea:	e7a6                	sd	s1,456(sp)
    800046ec:	e3ca                	sd	s2,448(sp)
    800046ee:	ff4e                	sd	s3,440(sp)
    800046f0:	fb52                	sd	s4,432(sp)
    800046f2:	f756                	sd	s5,424(sp)
    800046f4:	f35a                	sd	s6,416(sp)
    800046f6:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046f8:	e3040a13          	addi	s4,s0,-464
    800046fc:	10000613          	li	a2,256
    80004700:	4581                	li	a1,0
    80004702:	8552                	mv	a0,s4
    80004704:	a4bfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004708:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000470a:	89d2                	mv	s3,s4
    8000470c:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000470e:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004712:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004714:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004718:	00391513          	slli	a0,s2,0x3
    8000471c:	85d6                	mv	a1,s5
    8000471e:	e2843783          	ld	a5,-472(s0)
    80004722:	953e                	add	a0,a0,a5
    80004724:	d5cfd0ef          	jal	80001c80 <fetchaddr>
    80004728:	02054663          	bltz	a0,80004754 <sys_exec+0x92>
    if(uarg == 0){
    8000472c:	e2043783          	ld	a5,-480(s0)
    80004730:	c7a1                	beqz	a5,80004778 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004732:	9cdfb0ef          	jal	800000fe <kalloc>
    80004736:	85aa                	mv	a1,a0
    80004738:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000473c:	cd01                	beqz	a0,80004754 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000473e:	865a                	mv	a2,s6
    80004740:	e2043503          	ld	a0,-480(s0)
    80004744:	d86fd0ef          	jal	80001cca <fetchstr>
    80004748:	00054663          	bltz	a0,80004754 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000474c:	0905                	addi	s2,s2,1
    8000474e:	09a1                	addi	s3,s3,8
    80004750:	fd7914e3          	bne	s2,s7,80004718 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004754:	100a0a13          	addi	s4,s4,256
    80004758:	6088                	ld	a0,0(s1)
    8000475a:	cd31                	beqz	a0,800047b6 <sys_exec+0xf4>
    kfree(argv[i]);
    8000475c:	8c1fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004760:	04a1                	addi	s1,s1,8
    80004762:	ff449be3          	bne	s1,s4,80004758 <sys_exec+0x96>
  return -1;
    80004766:	557d                	li	a0,-1
    80004768:	64be                	ld	s1,456(sp)
    8000476a:	691e                	ld	s2,448(sp)
    8000476c:	79fa                	ld	s3,440(sp)
    8000476e:	7a5a                	ld	s4,432(sp)
    80004770:	7aba                	ld	s5,424(sp)
    80004772:	7b1a                	ld	s6,416(sp)
    80004774:	6bfa                	ld	s7,408(sp)
    80004776:	a881                	j	800047c6 <sys_exec+0x104>
      argv[i] = 0;
    80004778:	0009079b          	sext.w	a5,s2
    8000477c:	e3040593          	addi	a1,s0,-464
    80004780:	078e                	slli	a5,a5,0x3
    80004782:	97ae                	add	a5,a5,a1
    80004784:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004788:	f3040513          	addi	a0,s0,-208
    8000478c:	b9cff0ef          	jal	80003b28 <exec>
    80004790:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004792:	100a0a13          	addi	s4,s4,256
    80004796:	6088                	ld	a0,0(s1)
    80004798:	c511                	beqz	a0,800047a4 <sys_exec+0xe2>
    kfree(argv[i]);
    8000479a:	883fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000479e:	04a1                	addi	s1,s1,8
    800047a0:	ff449be3          	bne	s1,s4,80004796 <sys_exec+0xd4>
  return ret;
    800047a4:	854a                	mv	a0,s2
    800047a6:	64be                	ld	s1,456(sp)
    800047a8:	691e                	ld	s2,448(sp)
    800047aa:	79fa                	ld	s3,440(sp)
    800047ac:	7a5a                	ld	s4,432(sp)
    800047ae:	7aba                	ld	s5,424(sp)
    800047b0:	7b1a                	ld	s6,416(sp)
    800047b2:	6bfa                	ld	s7,408(sp)
    800047b4:	a809                	j	800047c6 <sys_exec+0x104>
  return -1;
    800047b6:	557d                	li	a0,-1
    800047b8:	64be                	ld	s1,456(sp)
    800047ba:	691e                	ld	s2,448(sp)
    800047bc:	79fa                	ld	s3,440(sp)
    800047be:	7a5a                	ld	s4,432(sp)
    800047c0:	7aba                	ld	s5,424(sp)
    800047c2:	7b1a                	ld	s6,416(sp)
    800047c4:	6bfa                	ld	s7,408(sp)
}
    800047c6:	60fe                	ld	ra,472(sp)
    800047c8:	645e                	ld	s0,464(sp)
    800047ca:	613d                	addi	sp,sp,480
    800047cc:	8082                	ret

00000000800047ce <sys_pipe>:

uint64
sys_pipe(void)
{
    800047ce:	7139                	addi	sp,sp,-64
    800047d0:	fc06                	sd	ra,56(sp)
    800047d2:	f822                	sd	s0,48(sp)
    800047d4:	f426                	sd	s1,40(sp)
    800047d6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800047d8:	e80fc0ef          	jal	80000e58 <myproc>
    800047dc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800047de:	fd840593          	addi	a1,s0,-40
    800047e2:	4501                	li	a0,0
    800047e4:	d42fd0ef          	jal	80001d26 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800047e8:	fc840593          	addi	a1,s0,-56
    800047ec:	fd040513          	addi	a0,s0,-48
    800047f0:	816ff0ef          	jal	80003806 <pipealloc>
    return -1;
    800047f4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800047f6:	0a054463          	bltz	a0,8000489e <sys_pipe+0xd0>
  fd0 = -1;
    800047fa:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047fe:	fd043503          	ld	a0,-48(s0)
    80004802:	edeff0ef          	jal	80003ee0 <fdalloc>
    80004806:	fca42223          	sw	a0,-60(s0)
    8000480a:	08054163          	bltz	a0,8000488c <sys_pipe+0xbe>
    8000480e:	fc843503          	ld	a0,-56(s0)
    80004812:	eceff0ef          	jal	80003ee0 <fdalloc>
    80004816:	fca42023          	sw	a0,-64(s0)
    8000481a:	06054063          	bltz	a0,8000487a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000481e:	4691                	li	a3,4
    80004820:	fc440613          	addi	a2,s0,-60
    80004824:	fd843583          	ld	a1,-40(s0)
    80004828:	68a8                	ld	a0,80(s1)
    8000482a:	9f4fc0ef          	jal	80000a1e <copyout>
    8000482e:	00054e63          	bltz	a0,8000484a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004832:	4691                	li	a3,4
    80004834:	fc040613          	addi	a2,s0,-64
    80004838:	fd843583          	ld	a1,-40(s0)
    8000483c:	95b6                	add	a1,a1,a3
    8000483e:	68a8                	ld	a0,80(s1)
    80004840:	9defc0ef          	jal	80000a1e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004844:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004846:	04055c63          	bgez	a0,8000489e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000484a:	fc442783          	lw	a5,-60(s0)
    8000484e:	07e9                	addi	a5,a5,26
    80004850:	078e                	slli	a5,a5,0x3
    80004852:	97a6                	add	a5,a5,s1
    80004854:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004858:	fc042783          	lw	a5,-64(s0)
    8000485c:	07e9                	addi	a5,a5,26
    8000485e:	078e                	slli	a5,a5,0x3
    80004860:	94be                	add	s1,s1,a5
    80004862:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004866:	fd043503          	ld	a0,-48(s0)
    8000486a:	c8dfe0ef          	jal	800034f6 <fileclose>
    fileclose(wf);
    8000486e:	fc843503          	ld	a0,-56(s0)
    80004872:	c85fe0ef          	jal	800034f6 <fileclose>
    return -1;
    80004876:	57fd                	li	a5,-1
    80004878:	a01d                	j	8000489e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000487a:	fc442783          	lw	a5,-60(s0)
    8000487e:	0007c763          	bltz	a5,8000488c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004882:	07e9                	addi	a5,a5,26
    80004884:	078e                	slli	a5,a5,0x3
    80004886:	97a6                	add	a5,a5,s1
    80004888:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000488c:	fd043503          	ld	a0,-48(s0)
    80004890:	c67fe0ef          	jal	800034f6 <fileclose>
    fileclose(wf);
    80004894:	fc843503          	ld	a0,-56(s0)
    80004898:	c5ffe0ef          	jal	800034f6 <fileclose>
    return -1;
    8000489c:	57fd                	li	a5,-1
}
    8000489e:	853e                	mv	a0,a5
    800048a0:	70e2                	ld	ra,56(sp)
    800048a2:	7442                	ld	s0,48(sp)
    800048a4:	74a2                	ld	s1,40(sp)
    800048a6:	6121                	addi	sp,sp,64
    800048a8:	8082                	ret
    800048aa:	0000                	unimp
    800048ac:	0000                	unimp
	...

00000000800048b0 <kernelvec>:
    800048b0:	7111                	addi	sp,sp,-256
    800048b2:	e006                	sd	ra,0(sp)
    800048b4:	e40a                	sd	sp,8(sp)
    800048b6:	e80e                	sd	gp,16(sp)
    800048b8:	ec12                	sd	tp,24(sp)
    800048ba:	f016                	sd	t0,32(sp)
    800048bc:	f41a                	sd	t1,40(sp)
    800048be:	f81e                	sd	t2,48(sp)
    800048c0:	e4aa                	sd	a0,72(sp)
    800048c2:	e8ae                	sd	a1,80(sp)
    800048c4:	ecb2                	sd	a2,88(sp)
    800048c6:	f0b6                	sd	a3,96(sp)
    800048c8:	f4ba                	sd	a4,104(sp)
    800048ca:	f8be                	sd	a5,112(sp)
    800048cc:	fcc2                	sd	a6,120(sp)
    800048ce:	e146                	sd	a7,128(sp)
    800048d0:	edf2                	sd	t3,216(sp)
    800048d2:	f1f6                	sd	t4,224(sp)
    800048d4:	f5fa                	sd	t5,232(sp)
    800048d6:	f9fe                	sd	t6,240(sp)
    800048d8:	ab8fd0ef          	jal	80001b90 <kerneltrap>
    800048dc:	6082                	ld	ra,0(sp)
    800048de:	6122                	ld	sp,8(sp)
    800048e0:	61c2                	ld	gp,16(sp)
    800048e2:	7282                	ld	t0,32(sp)
    800048e4:	7322                	ld	t1,40(sp)
    800048e6:	73c2                	ld	t2,48(sp)
    800048e8:	6526                	ld	a0,72(sp)
    800048ea:	65c6                	ld	a1,80(sp)
    800048ec:	6666                	ld	a2,88(sp)
    800048ee:	7686                	ld	a3,96(sp)
    800048f0:	7726                	ld	a4,104(sp)
    800048f2:	77c6                	ld	a5,112(sp)
    800048f4:	7866                	ld	a6,120(sp)
    800048f6:	688a                	ld	a7,128(sp)
    800048f8:	6e6e                	ld	t3,216(sp)
    800048fa:	7e8e                	ld	t4,224(sp)
    800048fc:	7f2e                	ld	t5,232(sp)
    800048fe:	7fce                	ld	t6,240(sp)
    80004900:	6111                	addi	sp,sp,256
    80004902:	10200073          	sret
	...

000000008000490e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000490e:	1141                	addi	sp,sp,-16
    80004910:	e406                	sd	ra,8(sp)
    80004912:	e022                	sd	s0,0(sp)
    80004914:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004916:	0c000737          	lui	a4,0xc000
    8000491a:	4785                	li	a5,1
    8000491c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000491e:	c35c                	sw	a5,4(a4)
}
    80004920:	60a2                	ld	ra,8(sp)
    80004922:	6402                	ld	s0,0(sp)
    80004924:	0141                	addi	sp,sp,16
    80004926:	8082                	ret

0000000080004928 <plicinithart>:

void
plicinithart(void)
{
    80004928:	1141                	addi	sp,sp,-16
    8000492a:	e406                	sd	ra,8(sp)
    8000492c:	e022                	sd	s0,0(sp)
    8000492e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004930:	cf4fc0ef          	jal	80000e24 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004934:	0085171b          	slliw	a4,a0,0x8
    80004938:	0c0027b7          	lui	a5,0xc002
    8000493c:	97ba                	add	a5,a5,a4
    8000493e:	40200713          	li	a4,1026
    80004942:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004946:	00d5151b          	slliw	a0,a0,0xd
    8000494a:	0c2017b7          	lui	a5,0xc201
    8000494e:	97aa                	add	a5,a5,a0
    80004950:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004954:	60a2                	ld	ra,8(sp)
    80004956:	6402                	ld	s0,0(sp)
    80004958:	0141                	addi	sp,sp,16
    8000495a:	8082                	ret

000000008000495c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000495c:	1141                	addi	sp,sp,-16
    8000495e:	e406                	sd	ra,8(sp)
    80004960:	e022                	sd	s0,0(sp)
    80004962:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004964:	cc0fc0ef          	jal	80000e24 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004968:	00d5151b          	slliw	a0,a0,0xd
    8000496c:	0c2017b7          	lui	a5,0xc201
    80004970:	97aa                	add	a5,a5,a0
  return irq;
}
    80004972:	43c8                	lw	a0,4(a5)
    80004974:	60a2                	ld	ra,8(sp)
    80004976:	6402                	ld	s0,0(sp)
    80004978:	0141                	addi	sp,sp,16
    8000497a:	8082                	ret

000000008000497c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	e426                	sd	s1,8(sp)
    80004984:	1000                	addi	s0,sp,32
    80004986:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004988:	c9cfc0ef          	jal	80000e24 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000498c:	00d5179b          	slliw	a5,a0,0xd
    80004990:	0c201737          	lui	a4,0xc201
    80004994:	97ba                	add	a5,a5,a4
    80004996:	c3c4                	sw	s1,4(a5)
}
    80004998:	60e2                	ld	ra,24(sp)
    8000499a:	6442                	ld	s0,16(sp)
    8000499c:	64a2                	ld	s1,8(sp)
    8000499e:	6105                	addi	sp,sp,32
    800049a0:	8082                	ret

00000000800049a2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800049a2:	1141                	addi	sp,sp,-16
    800049a4:	e406                	sd	ra,8(sp)
    800049a6:	e022                	sd	s0,0(sp)
    800049a8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800049aa:	479d                	li	a5,7
    800049ac:	04a7ca63          	blt	a5,a0,80004a00 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800049b0:	00017797          	auipc	a5,0x17
    800049b4:	bf078793          	addi	a5,a5,-1040 # 8001b5a0 <disk>
    800049b8:	97aa                	add	a5,a5,a0
    800049ba:	0187c783          	lbu	a5,24(a5)
    800049be:	e7b9                	bnez	a5,80004a0c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800049c0:	00451693          	slli	a3,a0,0x4
    800049c4:	00017797          	auipc	a5,0x17
    800049c8:	bdc78793          	addi	a5,a5,-1060 # 8001b5a0 <disk>
    800049cc:	6398                	ld	a4,0(a5)
    800049ce:	9736                	add	a4,a4,a3
    800049d0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800049d4:	6398                	ld	a4,0(a5)
    800049d6:	9736                	add	a4,a4,a3
    800049d8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800049dc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800049e0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800049e4:	97aa                	add	a5,a5,a0
    800049e6:	4705                	li	a4,1
    800049e8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800049ec:	00017517          	auipc	a0,0x17
    800049f0:	bcc50513          	addi	a0,a0,-1076 # 8001b5b8 <disk+0x18>
    800049f4:	a7ffc0ef          	jal	80001472 <wakeup>
}
    800049f8:	60a2                	ld	ra,8(sp)
    800049fa:	6402                	ld	s0,0(sp)
    800049fc:	0141                	addi	sp,sp,16
    800049fe:	8082                	ret
    panic("free_desc 1");
    80004a00:	00003517          	auipc	a0,0x3
    80004a04:	c5050513          	addi	a0,a0,-944 # 80007650 <etext+0x650>
    80004a08:	40f000ef          	jal	80005616 <panic>
    panic("free_desc 2");
    80004a0c:	00003517          	auipc	a0,0x3
    80004a10:	c5450513          	addi	a0,a0,-940 # 80007660 <etext+0x660>
    80004a14:	403000ef          	jal	80005616 <panic>

0000000080004a18 <virtio_disk_init>:
{
    80004a18:	1101                	addi	sp,sp,-32
    80004a1a:	ec06                	sd	ra,24(sp)
    80004a1c:	e822                	sd	s0,16(sp)
    80004a1e:	e426                	sd	s1,8(sp)
    80004a20:	e04a                	sd	s2,0(sp)
    80004a22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a24:	00003597          	auipc	a1,0x3
    80004a28:	c4c58593          	addi	a1,a1,-948 # 80007670 <etext+0x670>
    80004a2c:	00017517          	auipc	a0,0x17
    80004a30:	c9c50513          	addi	a0,a0,-868 # 8001b6c8 <disk+0x128>
    80004a34:	68d000ef          	jal	800058c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a38:	100017b7          	lui	a5,0x10001
    80004a3c:	4398                	lw	a4,0(a5)
    80004a3e:	2701                	sext.w	a4,a4
    80004a40:	747277b7          	lui	a5,0x74727
    80004a44:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a48:	14f71863          	bne	a4,a5,80004b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a4c:	100017b7          	lui	a5,0x10001
    80004a50:	43dc                	lw	a5,4(a5)
    80004a52:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a54:	4709                	li	a4,2
    80004a56:	14e79163          	bne	a5,a4,80004b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a5a:	100017b7          	lui	a5,0x10001
    80004a5e:	479c                	lw	a5,8(a5)
    80004a60:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a62:	12e79b63          	bne	a5,a4,80004b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a66:	100017b7          	lui	a5,0x10001
    80004a6a:	47d8                	lw	a4,12(a5)
    80004a6c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a6e:	554d47b7          	lui	a5,0x554d4
    80004a72:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a76:	12f71163          	bne	a4,a5,80004b98 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a7a:	100017b7          	lui	a5,0x10001
    80004a7e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a82:	4705                	li	a4,1
    80004a84:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a86:	470d                	li	a4,3
    80004a88:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a8a:	10001737          	lui	a4,0x10001
    80004a8e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a90:	c7ffe6b7          	lui	a3,0xc7ffe
    80004a94:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaf7f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a98:	8f75                	and	a4,a4,a3
    80004a9a:	100016b7          	lui	a3,0x10001
    80004a9e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004aa0:	472d                	li	a4,11
    80004aa2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004aa4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004aa8:	439c                	lw	a5,0(a5)
    80004aaa:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004aae:	8ba1                	andi	a5,a5,8
    80004ab0:	0e078a63          	beqz	a5,80004ba4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004ab4:	100017b7          	lui	a5,0x10001
    80004ab8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004abc:	43fc                	lw	a5,68(a5)
    80004abe:	2781                	sext.w	a5,a5
    80004ac0:	0e079863          	bnez	a5,80004bb0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ac4:	100017b7          	lui	a5,0x10001
    80004ac8:	5bdc                	lw	a5,52(a5)
    80004aca:	2781                	sext.w	a5,a5
  if(max == 0)
    80004acc:	0e078863          	beqz	a5,80004bbc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004ad0:	471d                	li	a4,7
    80004ad2:	0ef77b63          	bgeu	a4,a5,80004bc8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004ad6:	e28fb0ef          	jal	800000fe <kalloc>
    80004ada:	00017497          	auipc	s1,0x17
    80004ade:	ac648493          	addi	s1,s1,-1338 # 8001b5a0 <disk>
    80004ae2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004ae4:	e1afb0ef          	jal	800000fe <kalloc>
    80004ae8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004aea:	e14fb0ef          	jal	800000fe <kalloc>
    80004aee:	87aa                	mv	a5,a0
    80004af0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004af2:	6088                	ld	a0,0(s1)
    80004af4:	0e050063          	beqz	a0,80004bd4 <virtio_disk_init+0x1bc>
    80004af8:	00017717          	auipc	a4,0x17
    80004afc:	ab073703          	ld	a4,-1360(a4) # 8001b5a8 <disk+0x8>
    80004b00:	cb71                	beqz	a4,80004bd4 <virtio_disk_init+0x1bc>
    80004b02:	cbe9                	beqz	a5,80004bd4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b04:	6605                	lui	a2,0x1
    80004b06:	4581                	li	a1,0
    80004b08:	e46fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b0c:	00017497          	auipc	s1,0x17
    80004b10:	a9448493          	addi	s1,s1,-1388 # 8001b5a0 <disk>
    80004b14:	6605                	lui	a2,0x1
    80004b16:	4581                	li	a1,0
    80004b18:	6488                	ld	a0,8(s1)
    80004b1a:	e34fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004b1e:	6605                	lui	a2,0x1
    80004b20:	4581                	li	a1,0
    80004b22:	6888                	ld	a0,16(s1)
    80004b24:	e2afb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b28:	100017b7          	lui	a5,0x10001
    80004b2c:	4721                	li	a4,8
    80004b2e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b30:	4098                	lw	a4,0(s1)
    80004b32:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b36:	40d8                	lw	a4,4(s1)
    80004b38:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b3c:	649c                	ld	a5,8(s1)
    80004b3e:	0007869b          	sext.w	a3,a5
    80004b42:	10001737          	lui	a4,0x10001
    80004b46:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b4a:	9781                	srai	a5,a5,0x20
    80004b4c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b50:	689c                	ld	a5,16(s1)
    80004b52:	0007869b          	sext.w	a3,a5
    80004b56:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b5a:	9781                	srai	a5,a5,0x20
    80004b5c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b60:	4785                	li	a5,1
    80004b62:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b64:	00f48c23          	sb	a5,24(s1)
    80004b68:	00f48ca3          	sb	a5,25(s1)
    80004b6c:	00f48d23          	sb	a5,26(s1)
    80004b70:	00f48da3          	sb	a5,27(s1)
    80004b74:	00f48e23          	sb	a5,28(s1)
    80004b78:	00f48ea3          	sb	a5,29(s1)
    80004b7c:	00f48f23          	sb	a5,30(s1)
    80004b80:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b84:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b88:	07272823          	sw	s2,112(a4)
}
    80004b8c:	60e2                	ld	ra,24(sp)
    80004b8e:	6442                	ld	s0,16(sp)
    80004b90:	64a2                	ld	s1,8(sp)
    80004b92:	6902                	ld	s2,0(sp)
    80004b94:	6105                	addi	sp,sp,32
    80004b96:	8082                	ret
    panic("could not find virtio disk");
    80004b98:	00003517          	auipc	a0,0x3
    80004b9c:	ae850513          	addi	a0,a0,-1304 # 80007680 <etext+0x680>
    80004ba0:	277000ef          	jal	80005616 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004ba4:	00003517          	auipc	a0,0x3
    80004ba8:	afc50513          	addi	a0,a0,-1284 # 800076a0 <etext+0x6a0>
    80004bac:	26b000ef          	jal	80005616 <panic>
    panic("virtio disk should not be ready");
    80004bb0:	00003517          	auipc	a0,0x3
    80004bb4:	b1050513          	addi	a0,a0,-1264 # 800076c0 <etext+0x6c0>
    80004bb8:	25f000ef          	jal	80005616 <panic>
    panic("virtio disk has no queue 0");
    80004bbc:	00003517          	auipc	a0,0x3
    80004bc0:	b2450513          	addi	a0,a0,-1244 # 800076e0 <etext+0x6e0>
    80004bc4:	253000ef          	jal	80005616 <panic>
    panic("virtio disk max queue too short");
    80004bc8:	00003517          	auipc	a0,0x3
    80004bcc:	b3850513          	addi	a0,a0,-1224 # 80007700 <etext+0x700>
    80004bd0:	247000ef          	jal	80005616 <panic>
    panic("virtio disk kalloc");
    80004bd4:	00003517          	auipc	a0,0x3
    80004bd8:	b4c50513          	addi	a0,a0,-1204 # 80007720 <etext+0x720>
    80004bdc:	23b000ef          	jal	80005616 <panic>

0000000080004be0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004be0:	711d                	addi	sp,sp,-96
    80004be2:	ec86                	sd	ra,88(sp)
    80004be4:	e8a2                	sd	s0,80(sp)
    80004be6:	e4a6                	sd	s1,72(sp)
    80004be8:	e0ca                	sd	s2,64(sp)
    80004bea:	fc4e                	sd	s3,56(sp)
    80004bec:	f852                	sd	s4,48(sp)
    80004bee:	f456                	sd	s5,40(sp)
    80004bf0:	f05a                	sd	s6,32(sp)
    80004bf2:	ec5e                	sd	s7,24(sp)
    80004bf4:	e862                	sd	s8,16(sp)
    80004bf6:	1080                	addi	s0,sp,96
    80004bf8:	89aa                	mv	s3,a0
    80004bfa:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bfc:	00c52b83          	lw	s7,12(a0)
    80004c00:	001b9b9b          	slliw	s7,s7,0x1
    80004c04:	1b82                	slli	s7,s7,0x20
    80004c06:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c0a:	00017517          	auipc	a0,0x17
    80004c0e:	abe50513          	addi	a0,a0,-1346 # 8001b6c8 <disk+0x128>
    80004c12:	533000ef          	jal	80005944 <acquire>
  for(int i = 0; i < NUM; i++){
    80004c16:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c18:	00017a97          	auipc	s5,0x17
    80004c1c:	988a8a93          	addi	s5,s5,-1656 # 8001b5a0 <disk>
  for(int i = 0; i < 3; i++){
    80004c20:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c22:	5c7d                	li	s8,-1
    80004c24:	a095                	j	80004c88 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c26:	00fa8733          	add	a4,s5,a5
    80004c2a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c2e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c30:	0207c563          	bltz	a5,80004c5a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c34:	2905                	addiw	s2,s2,1
    80004c36:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c38:	05490c63          	beq	s2,s4,80004c90 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c3c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c3e:	00017717          	auipc	a4,0x17
    80004c42:	96270713          	addi	a4,a4,-1694 # 8001b5a0 <disk>
    80004c46:	4781                	li	a5,0
    if(disk.free[i]){
    80004c48:	01874683          	lbu	a3,24(a4)
    80004c4c:	fee9                	bnez	a3,80004c26 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004c4e:	2785                	addiw	a5,a5,1
    80004c50:	0705                	addi	a4,a4,1
    80004c52:	fe979be3          	bne	a5,s1,80004c48 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004c56:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004c5a:	01205d63          	blez	s2,80004c74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c5e:	fa042503          	lw	a0,-96(s0)
    80004c62:	d41ff0ef          	jal	800049a2 <free_desc>
      for(int j = 0; j < i; j++)
    80004c66:	4785                	li	a5,1
    80004c68:	0127d663          	bge	a5,s2,80004c74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c6c:	fa442503          	lw	a0,-92(s0)
    80004c70:	d33ff0ef          	jal	800049a2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c74:	00017597          	auipc	a1,0x17
    80004c78:	a5458593          	addi	a1,a1,-1452 # 8001b6c8 <disk+0x128>
    80004c7c:	00017517          	auipc	a0,0x17
    80004c80:	93c50513          	addi	a0,a0,-1732 # 8001b5b8 <disk+0x18>
    80004c84:	fa2fc0ef          	jal	80001426 <sleep>
  for(int i = 0; i < 3; i++){
    80004c88:	fa040613          	addi	a2,s0,-96
    80004c8c:	4901                	li	s2,0
    80004c8e:	b77d                	j	80004c3c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c90:	fa042503          	lw	a0,-96(s0)
    80004c94:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c98:	00017797          	auipc	a5,0x17
    80004c9c:	90878793          	addi	a5,a5,-1784 # 8001b5a0 <disk>
    80004ca0:	00a50713          	addi	a4,a0,10
    80004ca4:	0712                	slli	a4,a4,0x4
    80004ca6:	973e                	add	a4,a4,a5
    80004ca8:	01603633          	snez	a2,s6
    80004cac:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004cae:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004cb2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cb6:	6398                	ld	a4,0(a5)
    80004cb8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004cba:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004cbe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cc0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004cc2:	6390                	ld	a2,0(a5)
    80004cc4:	00d605b3          	add	a1,a2,a3
    80004cc8:	4741                	li	a4,16
    80004cca:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ccc:	4805                	li	a6,1
    80004cce:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004cd2:	fa442703          	lw	a4,-92(s0)
    80004cd6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cda:	0712                	slli	a4,a4,0x4
    80004cdc:	963a                	add	a2,a2,a4
    80004cde:	05898593          	addi	a1,s3,88
    80004ce2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ce4:	0007b883          	ld	a7,0(a5)
    80004ce8:	9746                	add	a4,a4,a7
    80004cea:	40000613          	li	a2,1024
    80004cee:	c710                	sw	a2,8(a4)
  if(write)
    80004cf0:	001b3613          	seqz	a2,s6
    80004cf4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004cf8:	01066633          	or	a2,a2,a6
    80004cfc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d00:	fa842583          	lw	a1,-88(s0)
    80004d04:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d08:	00250613          	addi	a2,a0,2
    80004d0c:	0612                	slli	a2,a2,0x4
    80004d0e:	963e                	add	a2,a2,a5
    80004d10:	577d                	li	a4,-1
    80004d12:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d16:	0592                	slli	a1,a1,0x4
    80004d18:	98ae                	add	a7,a7,a1
    80004d1a:	03068713          	addi	a4,a3,48
    80004d1e:	973e                	add	a4,a4,a5
    80004d20:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d24:	6398                	ld	a4,0(a5)
    80004d26:	972e                	add	a4,a4,a1
    80004d28:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d2c:	4689                	li	a3,2
    80004d2e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d32:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d36:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004d3a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d3e:	6794                	ld	a3,8(a5)
    80004d40:	0026d703          	lhu	a4,2(a3)
    80004d44:	8b1d                	andi	a4,a4,7
    80004d46:	0706                	slli	a4,a4,0x1
    80004d48:	96ba                	add	a3,a3,a4
    80004d4a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d4e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d52:	6798                	ld	a4,8(a5)
    80004d54:	00275783          	lhu	a5,2(a4)
    80004d58:	2785                	addiw	a5,a5,1
    80004d5a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d5e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d62:	100017b7          	lui	a5,0x10001
    80004d66:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d6a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004d6e:	00017917          	auipc	s2,0x17
    80004d72:	95a90913          	addi	s2,s2,-1702 # 8001b6c8 <disk+0x128>
  while(b->disk == 1) {
    80004d76:	84c2                	mv	s1,a6
    80004d78:	01079a63          	bne	a5,a6,80004d8c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004d7c:	85ca                	mv	a1,s2
    80004d7e:	854e                	mv	a0,s3
    80004d80:	ea6fc0ef          	jal	80001426 <sleep>
  while(b->disk == 1) {
    80004d84:	0049a783          	lw	a5,4(s3)
    80004d88:	fe978ae3          	beq	a5,s1,80004d7c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004d8c:	fa042903          	lw	s2,-96(s0)
    80004d90:	00290713          	addi	a4,s2,2
    80004d94:	0712                	slli	a4,a4,0x4
    80004d96:	00017797          	auipc	a5,0x17
    80004d9a:	80a78793          	addi	a5,a5,-2038 # 8001b5a0 <disk>
    80004d9e:	97ba                	add	a5,a5,a4
    80004da0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004da4:	00016997          	auipc	s3,0x16
    80004da8:	7fc98993          	addi	s3,s3,2044 # 8001b5a0 <disk>
    80004dac:	00491713          	slli	a4,s2,0x4
    80004db0:	0009b783          	ld	a5,0(s3)
    80004db4:	97ba                	add	a5,a5,a4
    80004db6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004dba:	854a                	mv	a0,s2
    80004dbc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004dc0:	be3ff0ef          	jal	800049a2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004dc4:	8885                	andi	s1,s1,1
    80004dc6:	f0fd                	bnez	s1,80004dac <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004dc8:	00017517          	auipc	a0,0x17
    80004dcc:	90050513          	addi	a0,a0,-1792 # 8001b6c8 <disk+0x128>
    80004dd0:	409000ef          	jal	800059d8 <release>
}
    80004dd4:	60e6                	ld	ra,88(sp)
    80004dd6:	6446                	ld	s0,80(sp)
    80004dd8:	64a6                	ld	s1,72(sp)
    80004dda:	6906                	ld	s2,64(sp)
    80004ddc:	79e2                	ld	s3,56(sp)
    80004dde:	7a42                	ld	s4,48(sp)
    80004de0:	7aa2                	ld	s5,40(sp)
    80004de2:	7b02                	ld	s6,32(sp)
    80004de4:	6be2                	ld	s7,24(sp)
    80004de6:	6c42                	ld	s8,16(sp)
    80004de8:	6125                	addi	sp,sp,96
    80004dea:	8082                	ret

0000000080004dec <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004dec:	1101                	addi	sp,sp,-32
    80004dee:	ec06                	sd	ra,24(sp)
    80004df0:	e822                	sd	s0,16(sp)
    80004df2:	e426                	sd	s1,8(sp)
    80004df4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004df6:	00016497          	auipc	s1,0x16
    80004dfa:	7aa48493          	addi	s1,s1,1962 # 8001b5a0 <disk>
    80004dfe:	00017517          	auipc	a0,0x17
    80004e02:	8ca50513          	addi	a0,a0,-1846 # 8001b6c8 <disk+0x128>
    80004e06:	33f000ef          	jal	80005944 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e0a:	100017b7          	lui	a5,0x10001
    80004e0e:	53bc                	lw	a5,96(a5)
    80004e10:	8b8d                	andi	a5,a5,3
    80004e12:	10001737          	lui	a4,0x10001
    80004e16:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004e18:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e1c:	689c                	ld	a5,16(s1)
    80004e1e:	0204d703          	lhu	a4,32(s1)
    80004e22:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e26:	04f70663          	beq	a4,a5,80004e72 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004e2a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e2e:	6898                	ld	a4,16(s1)
    80004e30:	0204d783          	lhu	a5,32(s1)
    80004e34:	8b9d                	andi	a5,a5,7
    80004e36:	078e                	slli	a5,a5,0x3
    80004e38:	97ba                	add	a5,a5,a4
    80004e3a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e3c:	00278713          	addi	a4,a5,2
    80004e40:	0712                	slli	a4,a4,0x4
    80004e42:	9726                	add	a4,a4,s1
    80004e44:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004e48:	e321                	bnez	a4,80004e88 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e4a:	0789                	addi	a5,a5,2
    80004e4c:	0792                	slli	a5,a5,0x4
    80004e4e:	97a6                	add	a5,a5,s1
    80004e50:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e52:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e56:	e1cfc0ef          	jal	80001472 <wakeup>

    disk.used_idx += 1;
    80004e5a:	0204d783          	lhu	a5,32(s1)
    80004e5e:	2785                	addiw	a5,a5,1
    80004e60:	17c2                	slli	a5,a5,0x30
    80004e62:	93c1                	srli	a5,a5,0x30
    80004e64:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e68:	6898                	ld	a4,16(s1)
    80004e6a:	00275703          	lhu	a4,2(a4)
    80004e6e:	faf71ee3          	bne	a4,a5,80004e2a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e72:	00017517          	auipc	a0,0x17
    80004e76:	85650513          	addi	a0,a0,-1962 # 8001b6c8 <disk+0x128>
    80004e7a:	35f000ef          	jal	800059d8 <release>
}
    80004e7e:	60e2                	ld	ra,24(sp)
    80004e80:	6442                	ld	s0,16(sp)
    80004e82:	64a2                	ld	s1,8(sp)
    80004e84:	6105                	addi	sp,sp,32
    80004e86:	8082                	ret
      panic("virtio_disk_intr status");
    80004e88:	00003517          	auipc	a0,0x3
    80004e8c:	8b050513          	addi	a0,a0,-1872 # 80007738 <etext+0x738>
    80004e90:	786000ef          	jal	80005616 <panic>

0000000080004e94 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e94:	1141                	addi	sp,sp,-16
    80004e96:	e406                	sd	ra,8(sp)
    80004e98:	e022                	sd	s0,0(sp)
    80004e9a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e9c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004ea0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004ea4:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004ea8:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004eac:	577d                	li	a4,-1
    80004eae:	177e                	slli	a4,a4,0x3f
    80004eb0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004eb2:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004eb6:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004eba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004ebe:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004ec2:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004ec6:	000f4737          	lui	a4,0xf4
    80004eca:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004ece:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ed0:	14d79073          	csrw	stimecmp,a5
}
    80004ed4:	60a2                	ld	ra,8(sp)
    80004ed6:	6402                	ld	s0,0(sp)
    80004ed8:	0141                	addi	sp,sp,16
    80004eda:	8082                	ret

0000000080004edc <start>:
{
    80004edc:	1141                	addi	sp,sp,-16
    80004ede:	e406                	sd	ra,8(sp)
    80004ee0:	e022                	sd	s0,0(sp)
    80004ee2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ee4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004ee8:	7779                	lui	a4,0xffffe
    80004eea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb01f>
    80004eee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ef0:	6705                	lui	a4,0x1
    80004ef2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ef6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ef8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004efc:	ffffb797          	auipc	a5,0xffffb
    80004f00:	40878793          	addi	a5,a5,1032 # 80000304 <main>
    80004f04:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004f08:	4781                	li	a5,0
    80004f0a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004f0e:	67c1                	lui	a5,0x10
    80004f10:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004f12:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004f16:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004f1a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004f1e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004f22:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004f26:	57fd                	li	a5,-1
    80004f28:	83a9                	srli	a5,a5,0xa
    80004f2a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004f2e:	47bd                	li	a5,15
    80004f30:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004f34:	f61ff0ef          	jal	80004e94 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004f38:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004f3c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f3e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f40:	30200073          	mret
}
    80004f44:	60a2                	ld	ra,8(sp)
    80004f46:	6402                	ld	s0,0(sp)
    80004f48:	0141                	addi	sp,sp,16
    80004f4a:	8082                	ret

0000000080004f4c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f4c:	711d                	addi	sp,sp,-96
    80004f4e:	ec86                	sd	ra,88(sp)
    80004f50:	e8a2                	sd	s0,80(sp)
    80004f52:	e0ca                	sd	s2,64(sp)
    80004f54:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004f56:	04c05863          	blez	a2,80004fa6 <consolewrite+0x5a>
    80004f5a:	e4a6                	sd	s1,72(sp)
    80004f5c:	fc4e                	sd	s3,56(sp)
    80004f5e:	f852                	sd	s4,48(sp)
    80004f60:	f456                	sd	s5,40(sp)
    80004f62:	f05a                	sd	s6,32(sp)
    80004f64:	ec5e                	sd	s7,24(sp)
    80004f66:	8a2a                	mv	s4,a0
    80004f68:	84ae                	mv	s1,a1
    80004f6a:	89b2                	mv	s3,a2
    80004f6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004f6e:	faf40b93          	addi	s7,s0,-81
    80004f72:	4b05                	li	s6,1
    80004f74:	5afd                	li	s5,-1
    80004f76:	86da                	mv	a3,s6
    80004f78:	8626                	mv	a2,s1
    80004f7a:	85d2                	mv	a1,s4
    80004f7c:	855e                	mv	a0,s7
    80004f7e:	849fc0ef          	jal	800017c6 <either_copyin>
    80004f82:	03550463          	beq	a0,s5,80004faa <consolewrite+0x5e>
      break;
    uartputc(c);
    80004f86:	faf44503          	lbu	a0,-81(s0)
    80004f8a:	02d000ef          	jal	800057b6 <uartputc>
  for(i = 0; i < n; i++){
    80004f8e:	2905                	addiw	s2,s2,1
    80004f90:	0485                	addi	s1,s1,1
    80004f92:	ff2992e3          	bne	s3,s2,80004f76 <consolewrite+0x2a>
    80004f96:	894e                	mv	s2,s3
    80004f98:	64a6                	ld	s1,72(sp)
    80004f9a:	79e2                	ld	s3,56(sp)
    80004f9c:	7a42                	ld	s4,48(sp)
    80004f9e:	7aa2                	ld	s5,40(sp)
    80004fa0:	7b02                	ld	s6,32(sp)
    80004fa2:	6be2                	ld	s7,24(sp)
    80004fa4:	a809                	j	80004fb6 <consolewrite+0x6a>
    80004fa6:	4901                	li	s2,0
    80004fa8:	a039                	j	80004fb6 <consolewrite+0x6a>
    80004faa:	64a6                	ld	s1,72(sp)
    80004fac:	79e2                	ld	s3,56(sp)
    80004fae:	7a42                	ld	s4,48(sp)
    80004fb0:	7aa2                	ld	s5,40(sp)
    80004fb2:	7b02                	ld	s6,32(sp)
    80004fb4:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004fb6:	854a                	mv	a0,s2
    80004fb8:	60e6                	ld	ra,88(sp)
    80004fba:	6446                	ld	s0,80(sp)
    80004fbc:	6906                	ld	s2,64(sp)
    80004fbe:	6125                	addi	sp,sp,96
    80004fc0:	8082                	ret

0000000080004fc2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004fc2:	711d                	addi	sp,sp,-96
    80004fc4:	ec86                	sd	ra,88(sp)
    80004fc6:	e8a2                	sd	s0,80(sp)
    80004fc8:	e4a6                	sd	s1,72(sp)
    80004fca:	e0ca                	sd	s2,64(sp)
    80004fcc:	fc4e                	sd	s3,56(sp)
    80004fce:	f852                	sd	s4,48(sp)
    80004fd0:	f456                	sd	s5,40(sp)
    80004fd2:	f05a                	sd	s6,32(sp)
    80004fd4:	1080                	addi	s0,sp,96
    80004fd6:	8aaa                	mv	s5,a0
    80004fd8:	8a2e                	mv	s4,a1
    80004fda:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fdc:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004fde:	0001e517          	auipc	a0,0x1e
    80004fe2:	70250513          	addi	a0,a0,1794 # 800236e0 <cons>
    80004fe6:	15f000ef          	jal	80005944 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fea:	0001e497          	auipc	s1,0x1e
    80004fee:	6f648493          	addi	s1,s1,1782 # 800236e0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ff2:	0001e917          	auipc	s2,0x1e
    80004ff6:	78690913          	addi	s2,s2,1926 # 80023778 <cons+0x98>
  while(n > 0){
    80004ffa:	0b305b63          	blez	s3,800050b0 <consoleread+0xee>
    while(cons.r == cons.w){
    80004ffe:	0984a783          	lw	a5,152(s1)
    80005002:	09c4a703          	lw	a4,156(s1)
    80005006:	0af71063          	bne	a4,a5,800050a6 <consoleread+0xe4>
      if(killed(myproc())){
    8000500a:	e4ffb0ef          	jal	80000e58 <myproc>
    8000500e:	e50fc0ef          	jal	8000165e <killed>
    80005012:	e12d                	bnez	a0,80005074 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80005014:	85a6                	mv	a1,s1
    80005016:	854a                	mv	a0,s2
    80005018:	c0efc0ef          	jal	80001426 <sleep>
    while(cons.r == cons.w){
    8000501c:	0984a783          	lw	a5,152(s1)
    80005020:	09c4a703          	lw	a4,156(s1)
    80005024:	fef703e3          	beq	a4,a5,8000500a <consoleread+0x48>
    80005028:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000502a:	0001e717          	auipc	a4,0x1e
    8000502e:	6b670713          	addi	a4,a4,1718 # 800236e0 <cons>
    80005032:	0017869b          	addiw	a3,a5,1
    80005036:	08d72c23          	sw	a3,152(a4)
    8000503a:	07f7f693          	andi	a3,a5,127
    8000503e:	9736                	add	a4,a4,a3
    80005040:	01874703          	lbu	a4,24(a4)
    80005044:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005048:	4691                	li	a3,4
    8000504a:	04db8663          	beq	s7,a3,80005096 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000504e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005052:	4685                	li	a3,1
    80005054:	faf40613          	addi	a2,s0,-81
    80005058:	85d2                	mv	a1,s4
    8000505a:	8556                	mv	a0,s5
    8000505c:	f20fc0ef          	jal	8000177c <either_copyout>
    80005060:	57fd                	li	a5,-1
    80005062:	04f50663          	beq	a0,a5,800050ae <consoleread+0xec>
      break;

    dst++;
    80005066:	0a05                	addi	s4,s4,1
    --n;
    80005068:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000506a:	47a9                	li	a5,10
    8000506c:	04fb8b63          	beq	s7,a5,800050c2 <consoleread+0x100>
    80005070:	6be2                	ld	s7,24(sp)
    80005072:	b761                	j	80004ffa <consoleread+0x38>
        release(&cons.lock);
    80005074:	0001e517          	auipc	a0,0x1e
    80005078:	66c50513          	addi	a0,a0,1644 # 800236e0 <cons>
    8000507c:	15d000ef          	jal	800059d8 <release>
        return -1;
    80005080:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005082:	60e6                	ld	ra,88(sp)
    80005084:	6446                	ld	s0,80(sp)
    80005086:	64a6                	ld	s1,72(sp)
    80005088:	6906                	ld	s2,64(sp)
    8000508a:	79e2                	ld	s3,56(sp)
    8000508c:	7a42                	ld	s4,48(sp)
    8000508e:	7aa2                	ld	s5,40(sp)
    80005090:	7b02                	ld	s6,32(sp)
    80005092:	6125                	addi	sp,sp,96
    80005094:	8082                	ret
      if(n < target){
    80005096:	0169fa63          	bgeu	s3,s6,800050aa <consoleread+0xe8>
        cons.r--;
    8000509a:	0001e717          	auipc	a4,0x1e
    8000509e:	6cf72f23          	sw	a5,1758(a4) # 80023778 <cons+0x98>
    800050a2:	6be2                	ld	s7,24(sp)
    800050a4:	a031                	j	800050b0 <consoleread+0xee>
    800050a6:	ec5e                	sd	s7,24(sp)
    800050a8:	b749                	j	8000502a <consoleread+0x68>
    800050aa:	6be2                	ld	s7,24(sp)
    800050ac:	a011                	j	800050b0 <consoleread+0xee>
    800050ae:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800050b0:	0001e517          	auipc	a0,0x1e
    800050b4:	63050513          	addi	a0,a0,1584 # 800236e0 <cons>
    800050b8:	121000ef          	jal	800059d8 <release>
  return target - n;
    800050bc:	413b053b          	subw	a0,s6,s3
    800050c0:	b7c9                	j	80005082 <consoleread+0xc0>
    800050c2:	6be2                	ld	s7,24(sp)
    800050c4:	b7f5                	j	800050b0 <consoleread+0xee>

00000000800050c6 <consputc>:
{
    800050c6:	1141                	addi	sp,sp,-16
    800050c8:	e406                	sd	ra,8(sp)
    800050ca:	e022                	sd	s0,0(sp)
    800050cc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800050ce:	10000793          	li	a5,256
    800050d2:	00f50863          	beq	a0,a5,800050e2 <consputc+0x1c>
    uartputc_sync(c);
    800050d6:	5fe000ef          	jal	800056d4 <uartputc_sync>
}
    800050da:	60a2                	ld	ra,8(sp)
    800050dc:	6402                	ld	s0,0(sp)
    800050de:	0141                	addi	sp,sp,16
    800050e0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050e2:	4521                	li	a0,8
    800050e4:	5f0000ef          	jal	800056d4 <uartputc_sync>
    800050e8:	02000513          	li	a0,32
    800050ec:	5e8000ef          	jal	800056d4 <uartputc_sync>
    800050f0:	4521                	li	a0,8
    800050f2:	5e2000ef          	jal	800056d4 <uartputc_sync>
    800050f6:	b7d5                	j	800050da <consputc+0x14>

00000000800050f8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050f8:	7179                	addi	sp,sp,-48
    800050fa:	f406                	sd	ra,40(sp)
    800050fc:	f022                	sd	s0,32(sp)
    800050fe:	ec26                	sd	s1,24(sp)
    80005100:	1800                	addi	s0,sp,48
    80005102:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005104:	0001e517          	auipc	a0,0x1e
    80005108:	5dc50513          	addi	a0,a0,1500 # 800236e0 <cons>
    8000510c:	039000ef          	jal	80005944 <acquire>

  switch(c){
    80005110:	47d5                	li	a5,21
    80005112:	08f48e63          	beq	s1,a5,800051ae <consoleintr+0xb6>
    80005116:	0297c563          	blt	a5,s1,80005140 <consoleintr+0x48>
    8000511a:	47a1                	li	a5,8
    8000511c:	0ef48863          	beq	s1,a5,8000520c <consoleintr+0x114>
    80005120:	47c1                	li	a5,16
    80005122:	10f49963          	bne	s1,a5,80005234 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005126:	eeafc0ef          	jal	80001810 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000512a:	0001e517          	auipc	a0,0x1e
    8000512e:	5b650513          	addi	a0,a0,1462 # 800236e0 <cons>
    80005132:	0a7000ef          	jal	800059d8 <release>
}
    80005136:	70a2                	ld	ra,40(sp)
    80005138:	7402                	ld	s0,32(sp)
    8000513a:	64e2                	ld	s1,24(sp)
    8000513c:	6145                	addi	sp,sp,48
    8000513e:	8082                	ret
  switch(c){
    80005140:	07f00793          	li	a5,127
    80005144:	0cf48463          	beq	s1,a5,8000520c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005148:	0001e717          	auipc	a4,0x1e
    8000514c:	59870713          	addi	a4,a4,1432 # 800236e0 <cons>
    80005150:	0a072783          	lw	a5,160(a4)
    80005154:	09872703          	lw	a4,152(a4)
    80005158:	9f99                	subw	a5,a5,a4
    8000515a:	07f00713          	li	a4,127
    8000515e:	fcf766e3          	bltu	a4,a5,8000512a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005162:	47b5                	li	a5,13
    80005164:	0cf48b63          	beq	s1,a5,8000523a <consoleintr+0x142>
      consputc(c);
    80005168:	8526                	mv	a0,s1
    8000516a:	f5dff0ef          	jal	800050c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000516e:	0001e797          	auipc	a5,0x1e
    80005172:	57278793          	addi	a5,a5,1394 # 800236e0 <cons>
    80005176:	0a07a683          	lw	a3,160(a5)
    8000517a:	0016871b          	addiw	a4,a3,1
    8000517e:	863a                	mv	a2,a4
    80005180:	0ae7a023          	sw	a4,160(a5)
    80005184:	07f6f693          	andi	a3,a3,127
    80005188:	97b6                	add	a5,a5,a3
    8000518a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000518e:	47a9                	li	a5,10
    80005190:	0cf48963          	beq	s1,a5,80005262 <consoleintr+0x16a>
    80005194:	4791                	li	a5,4
    80005196:	0cf48663          	beq	s1,a5,80005262 <consoleintr+0x16a>
    8000519a:	0001e797          	auipc	a5,0x1e
    8000519e:	5de7a783          	lw	a5,1502(a5) # 80023778 <cons+0x98>
    800051a2:	9f1d                	subw	a4,a4,a5
    800051a4:	08000793          	li	a5,128
    800051a8:	f8f711e3          	bne	a4,a5,8000512a <consoleintr+0x32>
    800051ac:	a85d                	j	80005262 <consoleintr+0x16a>
    800051ae:	e84a                	sd	s2,16(sp)
    800051b0:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800051b2:	0001e717          	auipc	a4,0x1e
    800051b6:	52e70713          	addi	a4,a4,1326 # 800236e0 <cons>
    800051ba:	0a072783          	lw	a5,160(a4)
    800051be:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051c2:	0001e497          	auipc	s1,0x1e
    800051c6:	51e48493          	addi	s1,s1,1310 # 800236e0 <cons>
    while(cons.e != cons.w &&
    800051ca:	4929                	li	s2,10
      consputc(BACKSPACE);
    800051cc:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800051d0:	02f70863          	beq	a4,a5,80005200 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051d4:	37fd                	addiw	a5,a5,-1
    800051d6:	07f7f713          	andi	a4,a5,127
    800051da:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051dc:	01874703          	lbu	a4,24(a4)
    800051e0:	03270363          	beq	a4,s2,80005206 <consoleintr+0x10e>
      cons.e--;
    800051e4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051e8:	854e                	mv	a0,s3
    800051ea:	eddff0ef          	jal	800050c6 <consputc>
    while(cons.e != cons.w &&
    800051ee:	0a04a783          	lw	a5,160(s1)
    800051f2:	09c4a703          	lw	a4,156(s1)
    800051f6:	fcf71fe3          	bne	a4,a5,800051d4 <consoleintr+0xdc>
    800051fa:	6942                	ld	s2,16(sp)
    800051fc:	69a2                	ld	s3,8(sp)
    800051fe:	b735                	j	8000512a <consoleintr+0x32>
    80005200:	6942                	ld	s2,16(sp)
    80005202:	69a2                	ld	s3,8(sp)
    80005204:	b71d                	j	8000512a <consoleintr+0x32>
    80005206:	6942                	ld	s2,16(sp)
    80005208:	69a2                	ld	s3,8(sp)
    8000520a:	b705                	j	8000512a <consoleintr+0x32>
    if(cons.e != cons.w){
    8000520c:	0001e717          	auipc	a4,0x1e
    80005210:	4d470713          	addi	a4,a4,1236 # 800236e0 <cons>
    80005214:	0a072783          	lw	a5,160(a4)
    80005218:	09c72703          	lw	a4,156(a4)
    8000521c:	f0f707e3          	beq	a4,a5,8000512a <consoleintr+0x32>
      cons.e--;
    80005220:	37fd                	addiw	a5,a5,-1
    80005222:	0001e717          	auipc	a4,0x1e
    80005226:	54f72f23          	sw	a5,1374(a4) # 80023780 <cons+0xa0>
      consputc(BACKSPACE);
    8000522a:	10000513          	li	a0,256
    8000522e:	e99ff0ef          	jal	800050c6 <consputc>
    80005232:	bde5                	j	8000512a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005234:	ee048be3          	beqz	s1,8000512a <consoleintr+0x32>
    80005238:	bf01                	j	80005148 <consoleintr+0x50>
      consputc(c);
    8000523a:	4529                	li	a0,10
    8000523c:	e8bff0ef          	jal	800050c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005240:	0001e797          	auipc	a5,0x1e
    80005244:	4a078793          	addi	a5,a5,1184 # 800236e0 <cons>
    80005248:	0a07a703          	lw	a4,160(a5)
    8000524c:	0017069b          	addiw	a3,a4,1
    80005250:	8636                	mv	a2,a3
    80005252:	0ad7a023          	sw	a3,160(a5)
    80005256:	07f77713          	andi	a4,a4,127
    8000525a:	97ba                	add	a5,a5,a4
    8000525c:	4729                	li	a4,10
    8000525e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005262:	0001e797          	auipc	a5,0x1e
    80005266:	50c7ad23          	sw	a2,1306(a5) # 8002377c <cons+0x9c>
        wakeup(&cons.r);
    8000526a:	0001e517          	auipc	a0,0x1e
    8000526e:	50e50513          	addi	a0,a0,1294 # 80023778 <cons+0x98>
    80005272:	a00fc0ef          	jal	80001472 <wakeup>
    80005276:	bd55                	j	8000512a <consoleintr+0x32>

0000000080005278 <consoleinit>:

void
consoleinit(void)
{
    80005278:	1141                	addi	sp,sp,-16
    8000527a:	e406                	sd	ra,8(sp)
    8000527c:	e022                	sd	s0,0(sp)
    8000527e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005280:	00002597          	auipc	a1,0x2
    80005284:	4d058593          	addi	a1,a1,1232 # 80007750 <etext+0x750>
    80005288:	0001e517          	auipc	a0,0x1e
    8000528c:	45850513          	addi	a0,a0,1112 # 800236e0 <cons>
    80005290:	630000ef          	jal	800058c0 <initlock>

  uartinit();
    80005294:	3ea000ef          	jal	8000567e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005298:	00015797          	auipc	a5,0x15
    8000529c:	2b078793          	addi	a5,a5,688 # 8001a548 <devsw>
    800052a0:	00000717          	auipc	a4,0x0
    800052a4:	d2270713          	addi	a4,a4,-734 # 80004fc2 <consoleread>
    800052a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800052aa:	00000717          	auipc	a4,0x0
    800052ae:	ca270713          	addi	a4,a4,-862 # 80004f4c <consolewrite>
    800052b2:	ef98                	sd	a4,24(a5)
}
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800052bc:	7179                	addi	sp,sp,-48
    800052be:	f406                	sd	ra,40(sp)
    800052c0:	f022                	sd	s0,32(sp)
    800052c2:	ec26                	sd	s1,24(sp)
    800052c4:	e84a                	sd	s2,16(sp)
    800052c6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800052c8:	c219                	beqz	a2,800052ce <printint+0x12>
    800052ca:	06054a63          	bltz	a0,8000533e <printint+0x82>
    x = -xx;
  else
    x = xx;
    800052ce:	4e01                	li	t3,0

  i = 0;
    800052d0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800052d4:	869a                	mv	a3,t1
  i = 0;
    800052d6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800052d8:	00002817          	auipc	a6,0x2
    800052dc:	64880813          	addi	a6,a6,1608 # 80007920 <digits>
    800052e0:	88be                	mv	a7,a5
    800052e2:	0017861b          	addiw	a2,a5,1
    800052e6:	87b2                	mv	a5,a2
    800052e8:	02b57733          	remu	a4,a0,a1
    800052ec:	9742                	add	a4,a4,a6
    800052ee:	00074703          	lbu	a4,0(a4)
    800052f2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800052f6:	872a                	mv	a4,a0
    800052f8:	02b55533          	divu	a0,a0,a1
    800052fc:	0685                	addi	a3,a3,1
    800052fe:	feb771e3          	bgeu	a4,a1,800052e0 <printint+0x24>

  if(sign)
    80005302:	000e0c63          	beqz	t3,8000531a <printint+0x5e>
    buf[i++] = '-';
    80005306:	fe060793          	addi	a5,a2,-32
    8000530a:	00878633          	add	a2,a5,s0
    8000530e:	02d00793          	li	a5,45
    80005312:	fef60823          	sb	a5,-16(a2)
    80005316:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000531a:	fff7891b          	addiw	s2,a5,-1
    8000531e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005322:	fff4c503          	lbu	a0,-1(s1)
    80005326:	da1ff0ef          	jal	800050c6 <consputc>
  while(--i >= 0)
    8000532a:	397d                	addiw	s2,s2,-1
    8000532c:	14fd                	addi	s1,s1,-1
    8000532e:	fe095ae3          	bgez	s2,80005322 <printint+0x66>
}
    80005332:	70a2                	ld	ra,40(sp)
    80005334:	7402                	ld	s0,32(sp)
    80005336:	64e2                	ld	s1,24(sp)
    80005338:	6942                	ld	s2,16(sp)
    8000533a:	6145                	addi	sp,sp,48
    8000533c:	8082                	ret
    x = -xx;
    8000533e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005342:	4e05                	li	t3,1
    x = -xx;
    80005344:	b771                	j	800052d0 <printint+0x14>

0000000080005346 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005346:	7155                	addi	sp,sp,-208
    80005348:	e506                	sd	ra,136(sp)
    8000534a:	e122                	sd	s0,128(sp)
    8000534c:	f0d2                	sd	s4,96(sp)
    8000534e:	0900                	addi	s0,sp,144
    80005350:	8a2a                	mv	s4,a0
    80005352:	e40c                	sd	a1,8(s0)
    80005354:	e810                	sd	a2,16(s0)
    80005356:	ec14                	sd	a3,24(s0)
    80005358:	f018                	sd	a4,32(s0)
    8000535a:	f41c                	sd	a5,40(s0)
    8000535c:	03043823          	sd	a6,48(s0)
    80005360:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005364:	0001e797          	auipc	a5,0x1e
    80005368:	43c7a783          	lw	a5,1084(a5) # 800237a0 <pr+0x18>
    8000536c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005370:	e3a1                	bnez	a5,800053b0 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005372:	00840793          	addi	a5,s0,8
    80005376:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000537a:	00054503          	lbu	a0,0(a0)
    8000537e:	26050663          	beqz	a0,800055ea <printf+0x2a4>
    80005382:	fca6                	sd	s1,120(sp)
    80005384:	f8ca                	sd	s2,112(sp)
    80005386:	f4ce                	sd	s3,104(sp)
    80005388:	ecd6                	sd	s5,88(sp)
    8000538a:	e8da                	sd	s6,80(sp)
    8000538c:	e0e2                	sd	s8,64(sp)
    8000538e:	fc66                	sd	s9,56(sp)
    80005390:	f86a                	sd	s10,48(sp)
    80005392:	f46e                	sd	s11,40(sp)
    80005394:	4981                	li	s3,0
    if(cx != '%'){
    80005396:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000539a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000539e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800053a2:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800053a6:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800053aa:	07000d93          	li	s11,112
    800053ae:	a80d                	j	800053e0 <printf+0x9a>
    acquire(&pr.lock);
    800053b0:	0001e517          	auipc	a0,0x1e
    800053b4:	3d850513          	addi	a0,a0,984 # 80023788 <pr>
    800053b8:	58c000ef          	jal	80005944 <acquire>
  va_start(ap, fmt);
    800053bc:	00840793          	addi	a5,s0,8
    800053c0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053c4:	000a4503          	lbu	a0,0(s4)
    800053c8:	fd4d                	bnez	a0,80005382 <printf+0x3c>
    800053ca:	ac3d                	j	80005608 <printf+0x2c2>
      consputc(cx);
    800053cc:	cfbff0ef          	jal	800050c6 <consputc>
      continue;
    800053d0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053d2:	2485                	addiw	s1,s1,1
    800053d4:	89a6                	mv	s3,s1
    800053d6:	94d2                	add	s1,s1,s4
    800053d8:	0004c503          	lbu	a0,0(s1)
    800053dc:	1e050b63          	beqz	a0,800055d2 <printf+0x28c>
    if(cx != '%'){
    800053e0:	ff5516e3          	bne	a0,s5,800053cc <printf+0x86>
    i++;
    800053e4:	0019879b          	addiw	a5,s3,1
    800053e8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800053ea:	00fa0733          	add	a4,s4,a5
    800053ee:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053f2:	1e090063          	beqz	s2,800055d2 <printf+0x28c>
    800053f6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800053fa:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800053fc:	c701                	beqz	a4,80005404 <printf+0xbe>
    800053fe:	97d2                	add	a5,a5,s4
    80005400:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005404:	03690763          	beq	s2,s6,80005432 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005408:	05890163          	beq	s2,s8,8000544a <printf+0x104>
    } else if(c0 == 'u'){
    8000540c:	0d990b63          	beq	s2,s9,800054e2 <printf+0x19c>
    } else if(c0 == 'x'){
    80005410:	13a90163          	beq	s2,s10,80005532 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005414:	13b90b63          	beq	s2,s11,8000554a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005418:	07300793          	li	a5,115
    8000541c:	16f90a63          	beq	s2,a5,80005590 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005420:	1b590463          	beq	s2,s5,800055c8 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005424:	8556                	mv	a0,s5
    80005426:	ca1ff0ef          	jal	800050c6 <consputc>
      consputc(c0);
    8000542a:	854a                	mv	a0,s2
    8000542c:	c9bff0ef          	jal	800050c6 <consputc>
    80005430:	b74d                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005432:	f8843783          	ld	a5,-120(s0)
    80005436:	00878713          	addi	a4,a5,8
    8000543a:	f8e43423          	sd	a4,-120(s0)
    8000543e:	4605                	li	a2,1
    80005440:	45a9                	li	a1,10
    80005442:	4388                	lw	a0,0(a5)
    80005444:	e79ff0ef          	jal	800052bc <printint>
    80005448:	b769                	j	800053d2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000544a:	03670663          	beq	a4,s6,80005476 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000544e:	05870263          	beq	a4,s8,80005492 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005452:	0b970463          	beq	a4,s9,800054fa <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005456:	fda717e3          	bne	a4,s10,80005424 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000545a:	f8843783          	ld	a5,-120(s0)
    8000545e:	00878713          	addi	a4,a5,8
    80005462:	f8e43423          	sd	a4,-120(s0)
    80005466:	4601                	li	a2,0
    80005468:	45c1                	li	a1,16
    8000546a:	6388                	ld	a0,0(a5)
    8000546c:	e51ff0ef          	jal	800052bc <printint>
      i += 1;
    80005470:	0029849b          	addiw	s1,s3,2
    80005474:	bfb9                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005476:	f8843783          	ld	a5,-120(s0)
    8000547a:	00878713          	addi	a4,a5,8
    8000547e:	f8e43423          	sd	a4,-120(s0)
    80005482:	4605                	li	a2,1
    80005484:	45a9                	li	a1,10
    80005486:	6388                	ld	a0,0(a5)
    80005488:	e35ff0ef          	jal	800052bc <printint>
      i += 1;
    8000548c:	0029849b          	addiw	s1,s3,2
    80005490:	b789                	j	800053d2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005492:	06400793          	li	a5,100
    80005496:	02f68863          	beq	a3,a5,800054c6 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000549a:	07500793          	li	a5,117
    8000549e:	06f68c63          	beq	a3,a5,80005516 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800054a2:	07800793          	li	a5,120
    800054a6:	f6f69fe3          	bne	a3,a5,80005424 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800054aa:	f8843783          	ld	a5,-120(s0)
    800054ae:	00878713          	addi	a4,a5,8
    800054b2:	f8e43423          	sd	a4,-120(s0)
    800054b6:	4601                	li	a2,0
    800054b8:	45c1                	li	a1,16
    800054ba:	6388                	ld	a0,0(a5)
    800054bc:	e01ff0ef          	jal	800052bc <printint>
      i += 2;
    800054c0:	0039849b          	addiw	s1,s3,3
    800054c4:	b739                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800054c6:	f8843783          	ld	a5,-120(s0)
    800054ca:	00878713          	addi	a4,a5,8
    800054ce:	f8e43423          	sd	a4,-120(s0)
    800054d2:	4605                	li	a2,1
    800054d4:	45a9                	li	a1,10
    800054d6:	6388                	ld	a0,0(a5)
    800054d8:	de5ff0ef          	jal	800052bc <printint>
      i += 2;
    800054dc:	0039849b          	addiw	s1,s3,3
    800054e0:	bdcd                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800054e2:	f8843783          	ld	a5,-120(s0)
    800054e6:	00878713          	addi	a4,a5,8
    800054ea:	f8e43423          	sd	a4,-120(s0)
    800054ee:	4601                	li	a2,0
    800054f0:	45a9                	li	a1,10
    800054f2:	4388                	lw	a0,0(a5)
    800054f4:	dc9ff0ef          	jal	800052bc <printint>
    800054f8:	bde9                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054fa:	f8843783          	ld	a5,-120(s0)
    800054fe:	00878713          	addi	a4,a5,8
    80005502:	f8e43423          	sd	a4,-120(s0)
    80005506:	4601                	li	a2,0
    80005508:	45a9                	li	a1,10
    8000550a:	6388                	ld	a0,0(a5)
    8000550c:	db1ff0ef          	jal	800052bc <printint>
      i += 1;
    80005510:	0029849b          	addiw	s1,s3,2
    80005514:	bd7d                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005516:	f8843783          	ld	a5,-120(s0)
    8000551a:	00878713          	addi	a4,a5,8
    8000551e:	f8e43423          	sd	a4,-120(s0)
    80005522:	4601                	li	a2,0
    80005524:	45a9                	li	a1,10
    80005526:	6388                	ld	a0,0(a5)
    80005528:	d95ff0ef          	jal	800052bc <printint>
      i += 2;
    8000552c:	0039849b          	addiw	s1,s3,3
    80005530:	b54d                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005532:	f8843783          	ld	a5,-120(s0)
    80005536:	00878713          	addi	a4,a5,8
    8000553a:	f8e43423          	sd	a4,-120(s0)
    8000553e:	4601                	li	a2,0
    80005540:	45c1                	li	a1,16
    80005542:	4388                	lw	a0,0(a5)
    80005544:	d79ff0ef          	jal	800052bc <printint>
    80005548:	b569                	j	800053d2 <printf+0x8c>
    8000554a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000554c:	f8843783          	ld	a5,-120(s0)
    80005550:	00878713          	addi	a4,a5,8
    80005554:	f8e43423          	sd	a4,-120(s0)
    80005558:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000555c:	03000513          	li	a0,48
    80005560:	b67ff0ef          	jal	800050c6 <consputc>
  consputc('x');
    80005564:	07800513          	li	a0,120
    80005568:	b5fff0ef          	jal	800050c6 <consputc>
    8000556c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000556e:	00002b97          	auipc	s7,0x2
    80005572:	3b2b8b93          	addi	s7,s7,946 # 80007920 <digits>
    80005576:	03c9d793          	srli	a5,s3,0x3c
    8000557a:	97de                	add	a5,a5,s7
    8000557c:	0007c503          	lbu	a0,0(a5)
    80005580:	b47ff0ef          	jal	800050c6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005584:	0992                	slli	s3,s3,0x4
    80005586:	397d                	addiw	s2,s2,-1
    80005588:	fe0917e3          	bnez	s2,80005576 <printf+0x230>
    8000558c:	6ba6                	ld	s7,72(sp)
    8000558e:	b591                	j	800053d2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005590:	f8843783          	ld	a5,-120(s0)
    80005594:	00878713          	addi	a4,a5,8
    80005598:	f8e43423          	sd	a4,-120(s0)
    8000559c:	0007b903          	ld	s2,0(a5)
    800055a0:	00090d63          	beqz	s2,800055ba <printf+0x274>
      for(; *s; s++)
    800055a4:	00094503          	lbu	a0,0(s2)
    800055a8:	e20505e3          	beqz	a0,800053d2 <printf+0x8c>
        consputc(*s);
    800055ac:	b1bff0ef          	jal	800050c6 <consputc>
      for(; *s; s++)
    800055b0:	0905                	addi	s2,s2,1
    800055b2:	00094503          	lbu	a0,0(s2)
    800055b6:	f97d                	bnez	a0,800055ac <printf+0x266>
    800055b8:	bd29                	j	800053d2 <printf+0x8c>
        s = "(null)";
    800055ba:	00002917          	auipc	s2,0x2
    800055be:	19e90913          	addi	s2,s2,414 # 80007758 <etext+0x758>
      for(; *s; s++)
    800055c2:	02800513          	li	a0,40
    800055c6:	b7dd                	j	800055ac <printf+0x266>
      consputc('%');
    800055c8:	02500513          	li	a0,37
    800055cc:	afbff0ef          	jal	800050c6 <consputc>
    800055d0:	b509                	j	800053d2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800055d2:	f7843783          	ld	a5,-136(s0)
    800055d6:	e385                	bnez	a5,800055f6 <printf+0x2b0>
    800055d8:	74e6                	ld	s1,120(sp)
    800055da:	7946                	ld	s2,112(sp)
    800055dc:	79a6                	ld	s3,104(sp)
    800055de:	6ae6                	ld	s5,88(sp)
    800055e0:	6b46                	ld	s6,80(sp)
    800055e2:	6c06                	ld	s8,64(sp)
    800055e4:	7ce2                	ld	s9,56(sp)
    800055e6:	7d42                	ld	s10,48(sp)
    800055e8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800055ea:	4501                	li	a0,0
    800055ec:	60aa                	ld	ra,136(sp)
    800055ee:	640a                	ld	s0,128(sp)
    800055f0:	7a06                	ld	s4,96(sp)
    800055f2:	6169                	addi	sp,sp,208
    800055f4:	8082                	ret
    800055f6:	74e6                	ld	s1,120(sp)
    800055f8:	7946                	ld	s2,112(sp)
    800055fa:	79a6                	ld	s3,104(sp)
    800055fc:	6ae6                	ld	s5,88(sp)
    800055fe:	6b46                	ld	s6,80(sp)
    80005600:	6c06                	ld	s8,64(sp)
    80005602:	7ce2                	ld	s9,56(sp)
    80005604:	7d42                	ld	s10,48(sp)
    80005606:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005608:	0001e517          	auipc	a0,0x1e
    8000560c:	18050513          	addi	a0,a0,384 # 80023788 <pr>
    80005610:	3c8000ef          	jal	800059d8 <release>
    80005614:	bfd9                	j	800055ea <printf+0x2a4>

0000000080005616 <panic>:

void
panic(char *s)
{
    80005616:	1101                	addi	sp,sp,-32
    80005618:	ec06                	sd	ra,24(sp)
    8000561a:	e822                	sd	s0,16(sp)
    8000561c:	e426                	sd	s1,8(sp)
    8000561e:	1000                	addi	s0,sp,32
    80005620:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005622:	0001e797          	auipc	a5,0x1e
    80005626:	1607af23          	sw	zero,382(a5) # 800237a0 <pr+0x18>
  printf("panic: ");
    8000562a:	00002517          	auipc	a0,0x2
    8000562e:	13650513          	addi	a0,a0,310 # 80007760 <etext+0x760>
    80005632:	d15ff0ef          	jal	80005346 <printf>
  printf("%s\n", s);
    80005636:	85a6                	mv	a1,s1
    80005638:	00002517          	auipc	a0,0x2
    8000563c:	13050513          	addi	a0,a0,304 # 80007768 <etext+0x768>
    80005640:	d07ff0ef          	jal	80005346 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005644:	4785                	li	a5,1
    80005646:	00005717          	auipc	a4,0x5
    8000564a:	e4f72b23          	sw	a5,-426(a4) # 8000a49c <panicked>
  for(;;)
    8000564e:	a001                	j	8000564e <panic+0x38>

0000000080005650 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005650:	1101                	addi	sp,sp,-32
    80005652:	ec06                	sd	ra,24(sp)
    80005654:	e822                	sd	s0,16(sp)
    80005656:	e426                	sd	s1,8(sp)
    80005658:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000565a:	0001e497          	auipc	s1,0x1e
    8000565e:	12e48493          	addi	s1,s1,302 # 80023788 <pr>
    80005662:	00002597          	auipc	a1,0x2
    80005666:	10e58593          	addi	a1,a1,270 # 80007770 <etext+0x770>
    8000566a:	8526                	mv	a0,s1
    8000566c:	254000ef          	jal	800058c0 <initlock>
  pr.locking = 1;
    80005670:	4785                	li	a5,1
    80005672:	cc9c                	sw	a5,24(s1)
}
    80005674:	60e2                	ld	ra,24(sp)
    80005676:	6442                	ld	s0,16(sp)
    80005678:	64a2                	ld	s1,8(sp)
    8000567a:	6105                	addi	sp,sp,32
    8000567c:	8082                	ret

000000008000567e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000567e:	1141                	addi	sp,sp,-16
    80005680:	e406                	sd	ra,8(sp)
    80005682:	e022                	sd	s0,0(sp)
    80005684:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005686:	100007b7          	lui	a5,0x10000
    8000568a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000568e:	10000737          	lui	a4,0x10000
    80005692:	f8000693          	li	a3,-128
    80005696:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000569a:	468d                	li	a3,3
    8000569c:	10000637          	lui	a2,0x10000
    800056a0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800056a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800056a8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800056ac:	8732                	mv	a4,a2
    800056ae:	461d                	li	a2,7
    800056b0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800056b4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800056b8:	00002597          	auipc	a1,0x2
    800056bc:	0c058593          	addi	a1,a1,192 # 80007778 <etext+0x778>
    800056c0:	0001e517          	auipc	a0,0x1e
    800056c4:	0e850513          	addi	a0,a0,232 # 800237a8 <uart_tx_lock>
    800056c8:	1f8000ef          	jal	800058c0 <initlock>
}
    800056cc:	60a2                	ld	ra,8(sp)
    800056ce:	6402                	ld	s0,0(sp)
    800056d0:	0141                	addi	sp,sp,16
    800056d2:	8082                	ret

00000000800056d4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800056d4:	1101                	addi	sp,sp,-32
    800056d6:	ec06                	sd	ra,24(sp)
    800056d8:	e822                	sd	s0,16(sp)
    800056da:	e426                	sd	s1,8(sp)
    800056dc:	1000                	addi	s0,sp,32
    800056de:	84aa                	mv	s1,a0
  push_off();
    800056e0:	224000ef          	jal	80005904 <push_off>

  if(panicked){
    800056e4:	00005797          	auipc	a5,0x5
    800056e8:	db87a783          	lw	a5,-584(a5) # 8000a49c <panicked>
    800056ec:	e795                	bnez	a5,80005718 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800056ee:	10000737          	lui	a4,0x10000
    800056f2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800056f4:	00074783          	lbu	a5,0(a4)
    800056f8:	0207f793          	andi	a5,a5,32
    800056fc:	dfe5                	beqz	a5,800056f4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800056fe:	0ff4f513          	zext.b	a0,s1
    80005702:	100007b7          	lui	a5,0x10000
    80005706:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000570a:	27e000ef          	jal	80005988 <pop_off>
}
    8000570e:	60e2                	ld	ra,24(sp)
    80005710:	6442                	ld	s0,16(sp)
    80005712:	64a2                	ld	s1,8(sp)
    80005714:	6105                	addi	sp,sp,32
    80005716:	8082                	ret
    for(;;)
    80005718:	a001                	j	80005718 <uartputc_sync+0x44>

000000008000571a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000571a:	00005797          	auipc	a5,0x5
    8000571e:	d867b783          	ld	a5,-634(a5) # 8000a4a0 <uart_tx_r>
    80005722:	00005717          	auipc	a4,0x5
    80005726:	d8673703          	ld	a4,-634(a4) # 8000a4a8 <uart_tx_w>
    8000572a:	08f70163          	beq	a4,a5,800057ac <uartstart+0x92>
{
    8000572e:	7139                	addi	sp,sp,-64
    80005730:	fc06                	sd	ra,56(sp)
    80005732:	f822                	sd	s0,48(sp)
    80005734:	f426                	sd	s1,40(sp)
    80005736:	f04a                	sd	s2,32(sp)
    80005738:	ec4e                	sd	s3,24(sp)
    8000573a:	e852                	sd	s4,16(sp)
    8000573c:	e456                	sd	s5,8(sp)
    8000573e:	e05a                	sd	s6,0(sp)
    80005740:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005742:	10000937          	lui	s2,0x10000
    80005746:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005748:	0001ea97          	auipc	s5,0x1e
    8000574c:	060a8a93          	addi	s5,s5,96 # 800237a8 <uart_tx_lock>
    uart_tx_r += 1;
    80005750:	00005497          	auipc	s1,0x5
    80005754:	d5048493          	addi	s1,s1,-688 # 8000a4a0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005758:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000575c:	00005997          	auipc	s3,0x5
    80005760:	d4c98993          	addi	s3,s3,-692 # 8000a4a8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005764:	00094703          	lbu	a4,0(s2)
    80005768:	02077713          	andi	a4,a4,32
    8000576c:	c715                	beqz	a4,80005798 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000576e:	01f7f713          	andi	a4,a5,31
    80005772:	9756                	add	a4,a4,s5
    80005774:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005778:	0785                	addi	a5,a5,1
    8000577a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000577c:	8526                	mv	a0,s1
    8000577e:	cf5fb0ef          	jal	80001472 <wakeup>
    WriteReg(THR, c);
    80005782:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005786:	609c                	ld	a5,0(s1)
    80005788:	0009b703          	ld	a4,0(s3)
    8000578c:	fcf71ce3          	bne	a4,a5,80005764 <uartstart+0x4a>
      ReadReg(ISR);
    80005790:	100007b7          	lui	a5,0x10000
    80005794:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005798:	70e2                	ld	ra,56(sp)
    8000579a:	7442                	ld	s0,48(sp)
    8000579c:	74a2                	ld	s1,40(sp)
    8000579e:	7902                	ld	s2,32(sp)
    800057a0:	69e2                	ld	s3,24(sp)
    800057a2:	6a42                	ld	s4,16(sp)
    800057a4:	6aa2                	ld	s5,8(sp)
    800057a6:	6b02                	ld	s6,0(sp)
    800057a8:	6121                	addi	sp,sp,64
    800057aa:	8082                	ret
      ReadReg(ISR);
    800057ac:	100007b7          	lui	a5,0x10000
    800057b0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800057b4:	8082                	ret

00000000800057b6 <uartputc>:
{
    800057b6:	7179                	addi	sp,sp,-48
    800057b8:	f406                	sd	ra,40(sp)
    800057ba:	f022                	sd	s0,32(sp)
    800057bc:	ec26                	sd	s1,24(sp)
    800057be:	e84a                	sd	s2,16(sp)
    800057c0:	e44e                	sd	s3,8(sp)
    800057c2:	e052                	sd	s4,0(sp)
    800057c4:	1800                	addi	s0,sp,48
    800057c6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800057c8:	0001e517          	auipc	a0,0x1e
    800057cc:	fe050513          	addi	a0,a0,-32 # 800237a8 <uart_tx_lock>
    800057d0:	174000ef          	jal	80005944 <acquire>
  if(panicked){
    800057d4:	00005797          	auipc	a5,0x5
    800057d8:	cc87a783          	lw	a5,-824(a5) # 8000a49c <panicked>
    800057dc:	efbd                	bnez	a5,8000585a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057de:	00005717          	auipc	a4,0x5
    800057e2:	cca73703          	ld	a4,-822(a4) # 8000a4a8 <uart_tx_w>
    800057e6:	00005797          	auipc	a5,0x5
    800057ea:	cba7b783          	ld	a5,-838(a5) # 8000a4a0 <uart_tx_r>
    800057ee:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800057f2:	0001e997          	auipc	s3,0x1e
    800057f6:	fb698993          	addi	s3,s3,-74 # 800237a8 <uart_tx_lock>
    800057fa:	00005497          	auipc	s1,0x5
    800057fe:	ca648493          	addi	s1,s1,-858 # 8000a4a0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005802:	00005917          	auipc	s2,0x5
    80005806:	ca690913          	addi	s2,s2,-858 # 8000a4a8 <uart_tx_w>
    8000580a:	00e79d63          	bne	a5,a4,80005824 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000580e:	85ce                	mv	a1,s3
    80005810:	8526                	mv	a0,s1
    80005812:	c15fb0ef          	jal	80001426 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005816:	00093703          	ld	a4,0(s2)
    8000581a:	609c                	ld	a5,0(s1)
    8000581c:	02078793          	addi	a5,a5,32
    80005820:	fee787e3          	beq	a5,a4,8000580e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005824:	0001e497          	auipc	s1,0x1e
    80005828:	f8448493          	addi	s1,s1,-124 # 800237a8 <uart_tx_lock>
    8000582c:	01f77793          	andi	a5,a4,31
    80005830:	97a6                	add	a5,a5,s1
    80005832:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005836:	0705                	addi	a4,a4,1
    80005838:	00005797          	auipc	a5,0x5
    8000583c:	c6e7b823          	sd	a4,-912(a5) # 8000a4a8 <uart_tx_w>
  uartstart();
    80005840:	edbff0ef          	jal	8000571a <uartstart>
  release(&uart_tx_lock);
    80005844:	8526                	mv	a0,s1
    80005846:	192000ef          	jal	800059d8 <release>
}
    8000584a:	70a2                	ld	ra,40(sp)
    8000584c:	7402                	ld	s0,32(sp)
    8000584e:	64e2                	ld	s1,24(sp)
    80005850:	6942                	ld	s2,16(sp)
    80005852:	69a2                	ld	s3,8(sp)
    80005854:	6a02                	ld	s4,0(sp)
    80005856:	6145                	addi	sp,sp,48
    80005858:	8082                	ret
    for(;;)
    8000585a:	a001                	j	8000585a <uartputc+0xa4>

000000008000585c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000585c:	1141                	addi	sp,sp,-16
    8000585e:	e406                	sd	ra,8(sp)
    80005860:	e022                	sd	s0,0(sp)
    80005862:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005864:	100007b7          	lui	a5,0x10000
    80005868:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000586c:	8b85                	andi	a5,a5,1
    8000586e:	cb89                	beqz	a5,80005880 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005870:	100007b7          	lui	a5,0x10000
    80005874:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005878:	60a2                	ld	ra,8(sp)
    8000587a:	6402                	ld	s0,0(sp)
    8000587c:	0141                	addi	sp,sp,16
    8000587e:	8082                	ret
    return -1;
    80005880:	557d                	li	a0,-1
    80005882:	bfdd                	j	80005878 <uartgetc+0x1c>

0000000080005884 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005884:	1101                	addi	sp,sp,-32
    80005886:	ec06                	sd	ra,24(sp)
    80005888:	e822                	sd	s0,16(sp)
    8000588a:	e426                	sd	s1,8(sp)
    8000588c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000588e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005890:	fcdff0ef          	jal	8000585c <uartgetc>
    if(c == -1)
    80005894:	00950563          	beq	a0,s1,8000589e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005898:	861ff0ef          	jal	800050f8 <consoleintr>
  while(1){
    8000589c:	bfd5                	j	80005890 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000589e:	0001e497          	auipc	s1,0x1e
    800058a2:	f0a48493          	addi	s1,s1,-246 # 800237a8 <uart_tx_lock>
    800058a6:	8526                	mv	a0,s1
    800058a8:	09c000ef          	jal	80005944 <acquire>
  uartstart();
    800058ac:	e6fff0ef          	jal	8000571a <uartstart>
  release(&uart_tx_lock);
    800058b0:	8526                	mv	a0,s1
    800058b2:	126000ef          	jal	800059d8 <release>
}
    800058b6:	60e2                	ld	ra,24(sp)
    800058b8:	6442                	ld	s0,16(sp)
    800058ba:	64a2                	ld	s1,8(sp)
    800058bc:	6105                	addi	sp,sp,32
    800058be:	8082                	ret

00000000800058c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800058c0:	1141                	addi	sp,sp,-16
    800058c2:	e406                	sd	ra,8(sp)
    800058c4:	e022                	sd	s0,0(sp)
    800058c6:	0800                	addi	s0,sp,16
  lk->name = name;
    800058c8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800058ca:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800058ce:	00053823          	sd	zero,16(a0)
}
    800058d2:	60a2                	ld	ra,8(sp)
    800058d4:	6402                	ld	s0,0(sp)
    800058d6:	0141                	addi	sp,sp,16
    800058d8:	8082                	ret

00000000800058da <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800058da:	411c                	lw	a5,0(a0)
    800058dc:	e399                	bnez	a5,800058e2 <holding+0x8>
    800058de:	4501                	li	a0,0
  return r;
}
    800058e0:	8082                	ret
{
    800058e2:	1101                	addi	sp,sp,-32
    800058e4:	ec06                	sd	ra,24(sp)
    800058e6:	e822                	sd	s0,16(sp)
    800058e8:	e426                	sd	s1,8(sp)
    800058ea:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800058ec:	6904                	ld	s1,16(a0)
    800058ee:	d4afb0ef          	jal	80000e38 <mycpu>
    800058f2:	40a48533          	sub	a0,s1,a0
    800058f6:	00153513          	seqz	a0,a0
}
    800058fa:	60e2                	ld	ra,24(sp)
    800058fc:	6442                	ld	s0,16(sp)
    800058fe:	64a2                	ld	s1,8(sp)
    80005900:	6105                	addi	sp,sp,32
    80005902:	8082                	ret

0000000080005904 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005904:	1101                	addi	sp,sp,-32
    80005906:	ec06                	sd	ra,24(sp)
    80005908:	e822                	sd	s0,16(sp)
    8000590a:	e426                	sd	s1,8(sp)
    8000590c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000590e:	100024f3          	csrr	s1,sstatus
    80005912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005916:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005918:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000591c:	d1cfb0ef          	jal	80000e38 <mycpu>
    80005920:	5d3c                	lw	a5,120(a0)
    80005922:	cb99                	beqz	a5,80005938 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005924:	d14fb0ef          	jal	80000e38 <mycpu>
    80005928:	5d3c                	lw	a5,120(a0)
    8000592a:	2785                	addiw	a5,a5,1
    8000592c:	dd3c                	sw	a5,120(a0)
}
    8000592e:	60e2                	ld	ra,24(sp)
    80005930:	6442                	ld	s0,16(sp)
    80005932:	64a2                	ld	s1,8(sp)
    80005934:	6105                	addi	sp,sp,32
    80005936:	8082                	ret
    mycpu()->intena = old;
    80005938:	d00fb0ef          	jal	80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000593c:	8085                	srli	s1,s1,0x1
    8000593e:	8885                	andi	s1,s1,1
    80005940:	dd64                	sw	s1,124(a0)
    80005942:	b7cd                	j	80005924 <push_off+0x20>

0000000080005944 <acquire>:
{
    80005944:	1101                	addi	sp,sp,-32
    80005946:	ec06                	sd	ra,24(sp)
    80005948:	e822                	sd	s0,16(sp)
    8000594a:	e426                	sd	s1,8(sp)
    8000594c:	1000                	addi	s0,sp,32
    8000594e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005950:	fb5ff0ef          	jal	80005904 <push_off>
  if(holding(lk))
    80005954:	8526                	mv	a0,s1
    80005956:	f85ff0ef          	jal	800058da <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000595a:	4705                	li	a4,1
  if(holding(lk))
    8000595c:	e105                	bnez	a0,8000597c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000595e:	87ba                	mv	a5,a4
    80005960:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005964:	2781                	sext.w	a5,a5
    80005966:	ffe5                	bnez	a5,8000595e <acquire+0x1a>
  __sync_synchronize();
    80005968:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000596c:	cccfb0ef          	jal	80000e38 <mycpu>
    80005970:	e888                	sd	a0,16(s1)
}
    80005972:	60e2                	ld	ra,24(sp)
    80005974:	6442                	ld	s0,16(sp)
    80005976:	64a2                	ld	s1,8(sp)
    80005978:	6105                	addi	sp,sp,32
    8000597a:	8082                	ret
    panic("acquire");
    8000597c:	00002517          	auipc	a0,0x2
    80005980:	e0450513          	addi	a0,a0,-508 # 80007780 <etext+0x780>
    80005984:	c93ff0ef          	jal	80005616 <panic>

0000000080005988 <pop_off>:

void
pop_off(void)
{
    80005988:	1141                	addi	sp,sp,-16
    8000598a:	e406                	sd	ra,8(sp)
    8000598c:	e022                	sd	s0,0(sp)
    8000598e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005990:	ca8fb0ef          	jal	80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005994:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005998:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000599a:	e39d                	bnez	a5,800059c0 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000599c:	5d3c                	lw	a5,120(a0)
    8000599e:	02f05763          	blez	a5,800059cc <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800059a2:	37fd                	addiw	a5,a5,-1
    800059a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800059a6:	eb89                	bnez	a5,800059b8 <pop_off+0x30>
    800059a8:	5d7c                	lw	a5,124(a0)
    800059aa:	c799                	beqz	a5,800059b8 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800059b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800059b8:	60a2                	ld	ra,8(sp)
    800059ba:	6402                	ld	s0,0(sp)
    800059bc:	0141                	addi	sp,sp,16
    800059be:	8082                	ret
    panic("pop_off - interruptible");
    800059c0:	00002517          	auipc	a0,0x2
    800059c4:	dc850513          	addi	a0,a0,-568 # 80007788 <etext+0x788>
    800059c8:	c4fff0ef          	jal	80005616 <panic>
    panic("pop_off");
    800059cc:	00002517          	auipc	a0,0x2
    800059d0:	dd450513          	addi	a0,a0,-556 # 800077a0 <etext+0x7a0>
    800059d4:	c43ff0ef          	jal	80005616 <panic>

00000000800059d8 <release>:
{
    800059d8:	1101                	addi	sp,sp,-32
    800059da:	ec06                	sd	ra,24(sp)
    800059dc:	e822                	sd	s0,16(sp)
    800059de:	e426                	sd	s1,8(sp)
    800059e0:	1000                	addi	s0,sp,32
    800059e2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800059e4:	ef7ff0ef          	jal	800058da <holding>
    800059e8:	c105                	beqz	a0,80005a08 <release+0x30>
  lk->cpu = 0;
    800059ea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800059ee:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800059f2:	0310000f          	fence	rw,w
    800059f6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800059fa:	f8fff0ef          	jal	80005988 <pop_off>
}
    800059fe:	60e2                	ld	ra,24(sp)
    80005a00:	6442                	ld	s0,16(sp)
    80005a02:	64a2                	ld	s1,8(sp)
    80005a04:	6105                	addi	sp,sp,32
    80005a06:	8082                	ret
    panic("release");
    80005a08:	00002517          	auipc	a0,0x2
    80005a0c:	da050513          	addi	a0,a0,-608 # 800077a8 <etext+0x7a8>
    80005a10:	c07ff0ef          	jal	80005616 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
