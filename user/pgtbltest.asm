
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00002917          	auipc	s2,0x2
  12:	ff293903          	ld	s2,-14(s2) # 2000 <testname>
  16:	66c000ef          	jal	682 <getpid>
  1a:	86aa                	mv	a3,a0
  1c:	8626                	mv	a2,s1
  1e:	85ca                	mv	a1,s2
  20:	00001517          	auipc	a0,0x1
  24:	bd050513          	addi	a0,a0,-1072 # bf0 <malloc+0xf4>
  28:	21d000ef          	jal	a44 <printf>
  exit(1);
  2c:	4505                	li	a0,1
  2e:	5d4000ef          	jal	602 <exit>

0000000000000032 <pgaccess_test>:
}

void 
pgaccess_test()
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	1000                	addi	s0,sp,32
  uint64 start_va = 0x400000;  // Starting virtual address of user pages.
  int numpages = 10;           // Number of pages to check.
  uint64 mask;
  printf("pgaccess() test\n\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	bde50513          	addi	a0,a0,-1058 # c18 <malloc+0x11c>
  42:	203000ef          	jal	a44 <printf>
  printf("va: %lu\n", start_va);
  46:	004005b7          	lui	a1,0x400
  4a:	00001517          	auipc	a0,0x1
  4e:	be650513          	addi	a0,a0,-1050 # c30 <malloc+0x134>
  52:	1f3000ef          	jal	a44 <printf>
  printf("num of pages: %d\n", numpages);
  56:	45a9                	li	a1,10
  58:	00001517          	auipc	a0,0x1
  5c:	be850513          	addi	a0,a0,-1048 # c40 <malloc+0x144>
  60:	1e5000ef          	jal	a44 <printf>
  
  // Call pgaccess: this will fill in the bitmask.
  if(pgaccess(start_va, numpages, (uint64)&mask) < 0) {
  64:	fe840613          	addi	a2,s0,-24
  68:	45a9                	li	a1,10
  6a:	00400537          	lui	a0,0x400
  6e:	66a000ef          	jal	6d8 <pgaccess>
  72:	02054463          	bltz	a0,9a <pgaccess_test+0x68>
      printf("pgaccess failed!\n");
      exit(1);
  }
  
  printf("Accessed bitmask: 0x%lx\n", mask);
  76:	fe843583          	ld	a1,-24(s0)
  7a:	00001517          	auipc	a0,0x1
  7e:	bf650513          	addi	a0,a0,-1034 # c70 <malloc+0x174>
  82:	1c3000ef          	jal	a44 <printf>
  printf("pgaccess(): OK\n");
  86:	00001517          	auipc	a0,0x1
  8a:	c0a50513          	addi	a0,a0,-1014 # c90 <malloc+0x194>
  8e:	1b7000ef          	jal	a44 <printf>
}
  92:	60e2                	ld	ra,24(sp)
  94:	6442                	ld	s0,16(sp)
  96:	6105                	addi	sp,sp,32
  98:	8082                	ret
      printf("pgaccess failed!\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	bbe50513          	addi	a0,a0,-1090 # c58 <malloc+0x15c>
  a2:	1a3000ef          	jal	a44 <printf>
      exit(1);
  a6:	4505                	li	a0,1
  a8:	55a000ef          	jal	602 <exit>

00000000000000ac <print_pte>:

void
print_pte(uint64 va)
{
  ac:	1101                	addi	sp,sp,-32
  ae:	ec06                	sd	ra,24(sp)
  b0:	e822                	sd	s0,16(sp)
  b2:	e426                	sd	s1,8(sp)
  b4:	1000                	addi	s0,sp,32
  b6:	84aa                	mv	s1,a0
    pte_t pte = (pte_t) pgpte((void *) va);
  b8:	60c000ef          	jal	6c4 <pgpte>
  bc:	862a                	mv	a2,a0
    printf("va 0x%lx pte 0x%lx pa 0x%lx perm 0x%lx\n", va, pte, PTE2PA(pte), PTE_FLAGS(pte));
  be:	00a55693          	srli	a3,a0,0xa
  c2:	3ff57713          	andi	a4,a0,1023
  c6:	06b2                	slli	a3,a3,0xc
  c8:	85a6                	mv	a1,s1
  ca:	00001517          	auipc	a0,0x1
  ce:	bd650513          	addi	a0,a0,-1066 # ca0 <malloc+0x1a4>
  d2:	173000ef          	jal	a44 <printf>
}
  d6:	60e2                	ld	ra,24(sp)
  d8:	6442                	ld	s0,16(sp)
  da:	64a2                	ld	s1,8(sp)
  dc:	6105                	addi	sp,sp,32
  de:	8082                	ret

00000000000000e0 <print_pgtbl>:

void
print_pgtbl()
{
  e0:	7179                	addi	sp,sp,-48
  e2:	f406                	sd	ra,40(sp)
  e4:	f022                	sd	s0,32(sp)
  e6:	ec26                	sd	s1,24(sp)
  e8:	e84a                	sd	s2,16(sp)
  ea:	e44e                	sd	s3,8(sp)
  ec:	1800                	addi	s0,sp,48
  printf("print_pgtbl starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	bda50513          	addi	a0,a0,-1062 # cc8 <malloc+0x1cc>
  f6:	14f000ef          	jal	a44 <printf>
  fa:	4481                	li	s1,0
  for (uint64 i = 0; i < 10; i++) {
  fc:	6985                	lui	s3,0x1
  fe:	6929                	lui	s2,0xa
    print_pte(i * PGSIZE);
 100:	8526                	mv	a0,s1
 102:	fabff0ef          	jal	ac <print_pte>
  for (uint64 i = 0; i < 10; i++) {
 106:	94ce                	add	s1,s1,s3
 108:	ff249ce3          	bne	s1,s2,100 <print_pgtbl+0x20>
 10c:	020004b7          	lui	s1,0x2000
 110:	14ed                	addi	s1,s1,-5 # 1fffffb <base+0x1ffdfdb>
 112:	04b6                	slli	s1,s1,0xd
  }
  uint64 top = MAXVA/PGSIZE;
  for (uint64 i = top-10; i < top; i++) {
 114:	6985                	lui	s3,0x1
 116:	4905                	li	s2,1
 118:	191a                	slli	s2,s2,0x26
    print_pte(i * PGSIZE);
 11a:	8526                	mv	a0,s1
 11c:	f91ff0ef          	jal	ac <print_pte>
  for (uint64 i = top-10; i < top; i++) {
 120:	94ce                	add	s1,s1,s3
 122:	ff249ce3          	bne	s1,s2,11a <print_pgtbl+0x3a>
  }
  printf("print_pgtbl: OK\n");
 126:	00001517          	auipc	a0,0x1
 12a:	bba50513          	addi	a0,a0,-1094 # ce0 <malloc+0x1e4>
 12e:	117000ef          	jal	a44 <printf>
}
 132:	70a2                	ld	ra,40(sp)
 134:	7402                	ld	s0,32(sp)
 136:	64e2                	ld	s1,24(sp)
 138:	6942                	ld	s2,16(sp)
 13a:	69a2                	ld	s3,8(sp)
 13c:	6145                	addi	sp,sp,48
 13e:	8082                	ret

0000000000000140 <ugetpid_test>:

void
ugetpid_test()
{
 140:	7179                	addi	sp,sp,-48
 142:	f406                	sd	ra,40(sp)
 144:	f022                	sd	s0,32(sp)
 146:	ec26                	sd	s1,24(sp)
 148:	e84a                	sd	s2,16(sp)
 14a:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
 14c:	00001517          	auipc	a0,0x1
 150:	bac50513          	addi	a0,a0,-1108 # cf8 <malloc+0x1fc>
 154:	0f1000ef          	jal	a44 <printf>
  testname = "ugetpid_test";
 158:	00001797          	auipc	a5,0x1
 15c:	bb878793          	addi	a5,a5,-1096 # d10 <malloc+0x214>
 160:	00002717          	auipc	a4,0x2
 164:	eaf73023          	sd	a5,-352(a4) # 2000 <testname>
 168:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
    if (ret != 0) {
      wait(&ret);
 16c:	fdc40913          	addi	s2,s0,-36
    int ret = fork();
 170:	48a000ef          	jal	5fa <fork>
 174:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
 178:	c905                	beqz	a0,1a8 <ugetpid_test+0x68>
      wait(&ret);
 17a:	854a                	mv	a0,s2
 17c:	48e000ef          	jal	60a <wait>
      if (ret != 0)
 180:	fdc42783          	lw	a5,-36(s0)
 184:	ef99                	bnez	a5,1a2 <ugetpid_test+0x62>
  for (i = 0; i < 64; i++) {
 186:	34fd                	addiw	s1,s1,-1
 188:	f4e5                	bnez	s1,170 <ugetpid_test+0x30>

    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	ba650513          	addi	a0,a0,-1114 # d30 <malloc+0x234>
 192:	0b3000ef          	jal	a44 <printf>
}
 196:	70a2                	ld	ra,40(sp)
 198:	7402                	ld	s0,32(sp)
 19a:	64e2                	ld	s1,24(sp)
 19c:	6942                	ld	s2,16(sp)
 19e:	6145                	addi	sp,sp,48
 1a0:	8082                	ret
        exit(1);
 1a2:	4505                	li	a0,1
 1a4:	45e000ef          	jal	602 <exit>
    if (getpid() != ugetpid())
 1a8:	4da000ef          	jal	682 <getpid>
 1ac:	84aa                	mv	s1,a0
 1ae:	432000ef          	jal	5e0 <ugetpid>
 1b2:	00a48863          	beq	s1,a0,1c2 <ugetpid_test+0x82>
      err("missmatched PID");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	b6a50513          	addi	a0,a0,-1174 # d20 <malloc+0x224>
 1be:	e43ff0ef          	jal	0 <err>
    exit(0);
 1c2:	4501                	li	a0,0
 1c4:	43e000ef          	jal	602 <exit>

00000000000001c8 <print_kpgtbl>:

void
print_kpgtbl()
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e406                	sd	ra,8(sp)
 1cc:	e022                	sd	s0,0(sp)
 1ce:	0800                	addi	s0,sp,16
  printf("print_kpgtbl starting\n");
 1d0:	00001517          	auipc	a0,0x1
 1d4:	b7850513          	addi	a0,a0,-1160 # d48 <malloc+0x24c>
 1d8:	06d000ef          	jal	a44 <printf>
  kpgtbl();
 1dc:	4f2000ef          	jal	6ce <kpgtbl>
  printf("print_kpgtbl: OK\n");
 1e0:	00001517          	auipc	a0,0x1
 1e4:	b8050513          	addi	a0,a0,-1152 # d60 <malloc+0x264>
 1e8:	05d000ef          	jal	a44 <printf>
}
 1ec:	60a2                	ld	ra,8(sp)
 1ee:	6402                	ld	s0,0(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <supercheck>:


void
supercheck(uint64 s)
{
 1f4:	7139                	addi	sp,sp,-64
 1f6:	fc06                	sd	ra,56(sp)
 1f8:	f822                	sd	s0,48(sp)
 1fa:	ec4e                	sd	s3,24(sp)
 1fc:	e05a                	sd	s6,0(sp)
 1fe:	0080                	addi	s0,sp,64
 200:	8b2a                	mv	s6,a0
  pte_t last_pte = 0;

  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 202:	002009b7          	lui	s3,0x200
 206:	99aa                	add	s3,s3,a0
 208:	ffe007b7          	lui	a5,0xffe00
 20c:	06f57163          	bgeu	a0,a5,26e <supercheck+0x7a>
 210:	f426                	sd	s1,40(sp)
 212:	f04a                	sd	s2,32(sp)
 214:	e852                	sd	s4,16(sp)
 216:	e456                	sd	s5,8(sp)
 218:	84aa                	mv	s1,a0
  pte_t last_pte = 0;
 21a:	4501                	li	a0,0
    if(pte == 0)
      err("no pte");
    if ((uint64) last_pte != 0 && pte != last_pte) {
        err("pte different");
    }
    if((pte & PTE_V) == 0 || (pte & PTE_R) == 0 || (pte & PTE_W) == 0){
 21c:	4a9d                	li	s5,7
  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 21e:	6a05                	lui	s4,0x1
 220:	a831                	j	23c <supercheck+0x48>
      err("no pte");
 222:	00001517          	auipc	a0,0x1
 226:	b5650513          	addi	a0,a0,-1194 # d78 <malloc+0x27c>
 22a:	dd7ff0ef          	jal	0 <err>
    if((pte & PTE_V) == 0 || (pte & PTE_R) == 0 || (pte & PTE_W) == 0){
 22e:	00757793          	andi	a5,a0,7
 232:	03579463          	bne	a5,s5,25a <supercheck+0x66>
  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 236:	94d2                	add	s1,s1,s4
 238:	0334f763          	bgeu	s1,s3,266 <supercheck+0x72>
    pte_t pte = (pte_t) pgpte((void *) p);
 23c:	892a                	mv	s2,a0
 23e:	8526                	mv	a0,s1
 240:	484000ef          	jal	6c4 <pgpte>
    if(pte == 0)
 244:	dd79                	beqz	a0,222 <supercheck+0x2e>
    if ((uint64) last_pte != 0 && pte != last_pte) {
 246:	fe0904e3          	beqz	s2,22e <supercheck+0x3a>
 24a:	ff2502e3          	beq	a0,s2,22e <supercheck+0x3a>
        err("pte different");
 24e:	00001517          	auipc	a0,0x1
 252:	b3250513          	addi	a0,a0,-1230 # d80 <malloc+0x284>
 256:	dabff0ef          	jal	0 <err>
      err("pte wrong");
 25a:	00001517          	auipc	a0,0x1
 25e:	b3650513          	addi	a0,a0,-1226 # d90 <malloc+0x294>
 262:	d9fff0ef          	jal	0 <err>
 266:	74a2                	ld	s1,40(sp)
 268:	7902                	ld	s2,32(sp)
 26a:	6a42                	ld	s4,16(sp)
 26c:	6aa2                	ld	s5,8(sp)
    }
    last_pte = pte;
  }

  for(int i = 0; i < 512; i += PGSIZE){
    *(int*)(s+i) = i;
 26e:	000b2023          	sw	zero,0(s6)

  for(int i = 0; i < 512; i += PGSIZE){
    if(*(int*)(s+i) != i)
      err("wrong value");
  }
}
 272:	70e2                	ld	ra,56(sp)
 274:	7442                	ld	s0,48(sp)
 276:	69e2                	ld	s3,24(sp)
 278:	6b02                	ld	s6,0(sp)
 27a:	6121                	addi	sp,sp,64
 27c:	8082                	ret

000000000000027e <superpg_test>:

void
superpg_test()
{
 27e:	7179                	addi	sp,sp,-48
 280:	f406                	sd	ra,40(sp)
 282:	f022                	sd	s0,32(sp)
 284:	ec26                	sd	s1,24(sp)
 286:	1800                	addi	s0,sp,48
  int pid;

  printf("superpg_test starting\n");
 288:	00001517          	auipc	a0,0x1
 28c:	b1850513          	addi	a0,a0,-1256 # da0 <malloc+0x2a4>
 290:	7b4000ef          	jal	a44 <printf>
  testname = "superpg_test";
 294:	00001797          	auipc	a5,0x1
 298:	b2478793          	addi	a5,a5,-1244 # db8 <malloc+0x2bc>
 29c:	00002717          	auipc	a4,0x2
 2a0:	d6f73223          	sd	a5,-668(a4) # 2000 <testname>
  
  char *end = sbrk(N);
 2a4:	00800537          	lui	a0,0x800
 2a8:	3e2000ef          	jal	68a <sbrk>
  if (end == 0 || end == (char*)0xffffffffffffffff)
 2ac:	fff50713          	addi	a4,a0,-1 # 7fffff <base+0x7fdfdf>
 2b0:	57f5                	li	a5,-3
 2b2:	04e7e463          	bltu	a5,a4,2fa <superpg_test+0x7c>
    err("sbrk failed");
  
  uint64 s = SUPERPGROUNDUP((uint64) end);
 2b6:	002007b7          	lui	a5,0x200
 2ba:	17fd                	addi	a5,a5,-1 # 1fffff <base+0x1fdfdf>
 2bc:	953e                	add	a0,a0,a5
 2be:	ffe007b7          	lui	a5,0xffe00
 2c2:	00f574b3          	and	s1,a0,a5
  supercheck(s);
 2c6:	8526                	mv	a0,s1
 2c8:	f2dff0ef          	jal	1f4 <supercheck>
  if((pid = fork()) < 0) {
 2cc:	32e000ef          	jal	5fa <fork>
 2d0:	02054b63          	bltz	a0,306 <superpg_test+0x88>
    err("fork");
  } else if(pid == 0) {
 2d4:	cd1d                	beqz	a0,312 <superpg_test+0x94>
    supercheck(s);
    exit(0);
  } else {
    int status;
    wait(&status);
 2d6:	fdc40513          	addi	a0,s0,-36
 2da:	330000ef          	jal	60a <wait>
    if (status != 0) {
 2de:	fdc42783          	lw	a5,-36(s0)
 2e2:	ef95                	bnez	a5,31e <superpg_test+0xa0>
      exit(0);
    }
  }
  printf("superpg_test: OK\n");  
 2e4:	00001517          	auipc	a0,0x1
 2e8:	afc50513          	addi	a0,a0,-1284 # de0 <malloc+0x2e4>
 2ec:	758000ef          	jal	a44 <printf>
}
 2f0:	70a2                	ld	ra,40(sp)
 2f2:	7402                	ld	s0,32(sp)
 2f4:	64e2                	ld	s1,24(sp)
 2f6:	6145                	addi	sp,sp,48
 2f8:	8082                	ret
    err("sbrk failed");
 2fa:	00001517          	auipc	a0,0x1
 2fe:	ace50513          	addi	a0,a0,-1330 # dc8 <malloc+0x2cc>
 302:	cffff0ef          	jal	0 <err>
    err("fork");
 306:	00001517          	auipc	a0,0x1
 30a:	ad250513          	addi	a0,a0,-1326 # dd8 <malloc+0x2dc>
 30e:	cf3ff0ef          	jal	0 <err>
    supercheck(s);
 312:	8526                	mv	a0,s1
 314:	ee1ff0ef          	jal	1f4 <supercheck>
    exit(0);
 318:	4501                	li	a0,0
 31a:	2e8000ef          	jal	602 <exit>
      exit(0);
 31e:	4501                	li	a0,0
 320:	2e2000ef          	jal	602 <exit>

0000000000000324 <main>:
{
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  print_pgtbl();
 32c:	db5ff0ef          	jal	e0 <print_pgtbl>
  pgaccess_test();
 330:	d03ff0ef          	jal	32 <pgaccess_test>
  superpg_test();
 334:	f4bff0ef          	jal	27e <superpg_test>
  printf("pgtbltest lap: all tests succeeded\n");
 338:	00001517          	auipc	a0,0x1
 33c:	ac050513          	addi	a0,a0,-1344 # df8 <malloc+0x2fc>
 340:	704000ef          	jal	a44 <printf>
  exit(0);
 344:	4501                	li	a0,0
 346:	2bc000ef          	jal	602 <exit>

000000000000034a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  extern int main();
  main();
 352:	fd3ff0ef          	jal	324 <main>
  exit(0);
 356:	4501                	li	a0,0
 358:	2aa000ef          	jal	602 <exit>

000000000000035c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 364:	87aa                	mv	a5,a0
 366:	0585                	addi	a1,a1,1 # 400001 <base+0x3fdfe1>
 368:	0785                	addi	a5,a5,1 # ffffffffffe00001 <base+0xffffffffffdfdfe1>
 36a:	fff5c703          	lbu	a4,-1(a1)
 36e:	fee78fa3          	sb	a4,-1(a5)
 372:	fb75                	bnez	a4,366 <strcpy+0xa>
    ;
  return os;
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 384:	00054783          	lbu	a5,0(a0)
 388:	cb91                	beqz	a5,39c <strcmp+0x20>
 38a:	0005c703          	lbu	a4,0(a1)
 38e:	00f71763          	bne	a4,a5,39c <strcmp+0x20>
    p++, q++;
 392:	0505                	addi	a0,a0,1
 394:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 396:	00054783          	lbu	a5,0(a0)
 39a:	fbe5                	bnez	a5,38a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 39c:	0005c503          	lbu	a0,0(a1)
}
 3a0:	40a7853b          	subw	a0,a5,a0
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <strlen>:

uint
strlen(const char *s)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e406                	sd	ra,8(sp)
 3b0:	e022                	sd	s0,0(sp)
 3b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	cf99                	beqz	a5,3d6 <strlen+0x2a>
 3ba:	0505                	addi	a0,a0,1
 3bc:	87aa                	mv	a5,a0
 3be:	86be                	mv	a3,a5
 3c0:	0785                	addi	a5,a5,1
 3c2:	fff7c703          	lbu	a4,-1(a5)
 3c6:	ff65                	bnez	a4,3be <strlen+0x12>
 3c8:	40a6853b          	subw	a0,a3,a0
 3cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 3ce:	60a2                	ld	ra,8(sp)
 3d0:	6402                	ld	s0,0(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret
  for(n = 0; s[n]; n++)
 3d6:	4501                	li	a0,0
 3d8:	bfdd                	j	3ce <strlen+0x22>

00000000000003da <memset>:

void*
memset(void *dst, int c, uint n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e406                	sd	ra,8(sp)
 3de:	e022                	sd	s0,0(sp)
 3e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3e2:	ca19                	beqz	a2,3f8 <memset+0x1e>
 3e4:	87aa                	mv	a5,a0
 3e6:	1602                	slli	a2,a2,0x20
 3e8:	9201                	srli	a2,a2,0x20
 3ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3f2:	0785                	addi	a5,a5,1
 3f4:	fee79de3          	bne	a5,a4,3ee <memset+0x14>
  }
  return dst;
}
 3f8:	60a2                	ld	ra,8(sp)
 3fa:	6402                	ld	s0,0(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret

0000000000000400 <strchr>:

char*
strchr(const char *s, char c)
{
 400:	1141                	addi	sp,sp,-16
 402:	e406                	sd	ra,8(sp)
 404:	e022                	sd	s0,0(sp)
 406:	0800                	addi	s0,sp,16
  for(; *s; s++)
 408:	00054783          	lbu	a5,0(a0)
 40c:	cf81                	beqz	a5,424 <strchr+0x24>
    if(*s == c)
 40e:	00f58763          	beq	a1,a5,41c <strchr+0x1c>
  for(; *s; s++)
 412:	0505                	addi	a0,a0,1
 414:	00054783          	lbu	a5,0(a0)
 418:	fbfd                	bnez	a5,40e <strchr+0xe>
      return (char*)s;
  return 0;
 41a:	4501                	li	a0,0
}
 41c:	60a2                	ld	ra,8(sp)
 41e:	6402                	ld	s0,0(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
  return 0;
 424:	4501                	li	a0,0
 426:	bfdd                	j	41c <strchr+0x1c>

0000000000000428 <gets>:

char*
gets(char *buf, int max)
{
 428:	7159                	addi	sp,sp,-112
 42a:	f486                	sd	ra,104(sp)
 42c:	f0a2                	sd	s0,96(sp)
 42e:	eca6                	sd	s1,88(sp)
 430:	e8ca                	sd	s2,80(sp)
 432:	e4ce                	sd	s3,72(sp)
 434:	e0d2                	sd	s4,64(sp)
 436:	fc56                	sd	s5,56(sp)
 438:	f85a                	sd	s6,48(sp)
 43a:	f45e                	sd	s7,40(sp)
 43c:	f062                	sd	s8,32(sp)
 43e:	ec66                	sd	s9,24(sp)
 440:	e86a                	sd	s10,16(sp)
 442:	1880                	addi	s0,sp,112
 444:	8caa                	mv	s9,a0
 446:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 448:	892a                	mv	s2,a0
 44a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 44c:	f9f40b13          	addi	s6,s0,-97
 450:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 452:	4ba9                	li	s7,10
 454:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 456:	8d26                	mv	s10,s1
 458:	0014899b          	addiw	s3,s1,1
 45c:	84ce                	mv	s1,s3
 45e:	0349d563          	bge	s3,s4,488 <gets+0x60>
    cc = read(0, &c, 1);
 462:	8656                	mv	a2,s5
 464:	85da                	mv	a1,s6
 466:	4501                	li	a0,0
 468:	1b2000ef          	jal	61a <read>
    if(cc < 1)
 46c:	00a05e63          	blez	a0,488 <gets+0x60>
    buf[i++] = c;
 470:	f9f44783          	lbu	a5,-97(s0)
 474:	00f90023          	sb	a5,0(s2) # a000 <base+0x7fe0>
    if(c == '\n' || c == '\r')
 478:	01778763          	beq	a5,s7,486 <gets+0x5e>
 47c:	0905                	addi	s2,s2,1
 47e:	fd879ce3          	bne	a5,s8,456 <gets+0x2e>
    buf[i++] = c;
 482:	8d4e                	mv	s10,s3
 484:	a011                	j	488 <gets+0x60>
 486:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 488:	9d66                	add	s10,s10,s9
 48a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 48e:	8566                	mv	a0,s9
 490:	70a6                	ld	ra,104(sp)
 492:	7406                	ld	s0,96(sp)
 494:	64e6                	ld	s1,88(sp)
 496:	6946                	ld	s2,80(sp)
 498:	69a6                	ld	s3,72(sp)
 49a:	6a06                	ld	s4,64(sp)
 49c:	7ae2                	ld	s5,56(sp)
 49e:	7b42                	ld	s6,48(sp)
 4a0:	7ba2                	ld	s7,40(sp)
 4a2:	7c02                	ld	s8,32(sp)
 4a4:	6ce2                	ld	s9,24(sp)
 4a6:	6d42                	ld	s10,16(sp)
 4a8:	6165                	addi	sp,sp,112
 4aa:	8082                	ret

00000000000004ac <stat>:

int
stat(const char *n, struct stat *st)
{
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	e04a                	sd	s2,0(sp)
 4b4:	1000                	addi	s0,sp,32
 4b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b8:	4581                	li	a1,0
 4ba:	188000ef          	jal	642 <open>
  if(fd < 0)
 4be:	02054263          	bltz	a0,4e2 <stat+0x36>
 4c2:	e426                	sd	s1,8(sp)
 4c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4c6:	85ca                	mv	a1,s2
 4c8:	192000ef          	jal	65a <fstat>
 4cc:	892a                	mv	s2,a0
  close(fd);
 4ce:	8526                	mv	a0,s1
 4d0:	15a000ef          	jal	62a <close>
  return r;
 4d4:	64a2                	ld	s1,8(sp)
}
 4d6:	854a                	mv	a0,s2
 4d8:	60e2                	ld	ra,24(sp)
 4da:	6442                	ld	s0,16(sp)
 4dc:	6902                	ld	s2,0(sp)
 4de:	6105                	addi	sp,sp,32
 4e0:	8082                	ret
    return -1;
 4e2:	597d                	li	s2,-1
 4e4:	bfcd                	j	4d6 <stat+0x2a>

00000000000004e6 <atoi>:

int
atoi(const char *s)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e406                	sd	ra,8(sp)
 4ea:	e022                	sd	s0,0(sp)
 4ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ee:	00054683          	lbu	a3,0(a0)
 4f2:	fd06879b          	addiw	a5,a3,-48
 4f6:	0ff7f793          	zext.b	a5,a5
 4fa:	4625                	li	a2,9
 4fc:	02f66963          	bltu	a2,a5,52e <atoi+0x48>
 500:	872a                	mv	a4,a0
  n = 0;
 502:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 504:	0705                	addi	a4,a4,1
 506:	0025179b          	slliw	a5,a0,0x2
 50a:	9fa9                	addw	a5,a5,a0
 50c:	0017979b          	slliw	a5,a5,0x1
 510:	9fb5                	addw	a5,a5,a3
 512:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 516:	00074683          	lbu	a3,0(a4)
 51a:	fd06879b          	addiw	a5,a3,-48
 51e:	0ff7f793          	zext.b	a5,a5
 522:	fef671e3          	bgeu	a2,a5,504 <atoi+0x1e>
  return n;
}
 526:	60a2                	ld	ra,8(sp)
 528:	6402                	ld	s0,0(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
  n = 0;
 52e:	4501                	li	a0,0
 530:	bfdd                	j	526 <atoi+0x40>

0000000000000532 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 532:	1141                	addi	sp,sp,-16
 534:	e406                	sd	ra,8(sp)
 536:	e022                	sd	s0,0(sp)
 538:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 53a:	02b57563          	bgeu	a0,a1,564 <memmove+0x32>
    while(n-- > 0)
 53e:	00c05f63          	blez	a2,55c <memmove+0x2a>
 542:	1602                	slli	a2,a2,0x20
 544:	9201                	srli	a2,a2,0x20
 546:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 54a:	872a                	mv	a4,a0
      *dst++ = *src++;
 54c:	0585                	addi	a1,a1,1
 54e:	0705                	addi	a4,a4,1
 550:	fff5c683          	lbu	a3,-1(a1)
 554:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 558:	fee79ae3          	bne	a5,a4,54c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret
    dst += n;
 564:	00c50733          	add	a4,a0,a2
    src += n;
 568:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 56a:	fec059e3          	blez	a2,55c <memmove+0x2a>
 56e:	fff6079b          	addiw	a5,a2,-1
 572:	1782                	slli	a5,a5,0x20
 574:	9381                	srli	a5,a5,0x20
 576:	fff7c793          	not	a5,a5
 57a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 57c:	15fd                	addi	a1,a1,-1
 57e:	177d                	addi	a4,a4,-1
 580:	0005c683          	lbu	a3,0(a1)
 584:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 588:	fef71ae3          	bne	a4,a5,57c <memmove+0x4a>
 58c:	bfc1                	j	55c <memmove+0x2a>

000000000000058e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 58e:	1141                	addi	sp,sp,-16
 590:	e406                	sd	ra,8(sp)
 592:	e022                	sd	s0,0(sp)
 594:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 596:	ca0d                	beqz	a2,5c8 <memcmp+0x3a>
 598:	fff6069b          	addiw	a3,a2,-1
 59c:	1682                	slli	a3,a3,0x20
 59e:	9281                	srli	a3,a3,0x20
 5a0:	0685                	addi	a3,a3,1
 5a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5a4:	00054783          	lbu	a5,0(a0)
 5a8:	0005c703          	lbu	a4,0(a1)
 5ac:	00e79863          	bne	a5,a4,5bc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 5b0:	0505                	addi	a0,a0,1
    p2++;
 5b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5b4:	fed518e3          	bne	a0,a3,5a4 <memcmp+0x16>
  }
  return 0;
 5b8:	4501                	li	a0,0
 5ba:	a019                	j	5c0 <memcmp+0x32>
      return *p1 - *p2;
 5bc:	40e7853b          	subw	a0,a5,a4
}
 5c0:	60a2                	ld	ra,8(sp)
 5c2:	6402                	ld	s0,0(sp)
 5c4:	0141                	addi	sp,sp,16
 5c6:	8082                	ret
  return 0;
 5c8:	4501                	li	a0,0
 5ca:	bfdd                	j	5c0 <memcmp+0x32>

00000000000005cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5cc:	1141                	addi	sp,sp,-16
 5ce:	e406                	sd	ra,8(sp)
 5d0:	e022                	sd	s0,0(sp)
 5d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5d4:	f5fff0ef          	jal	532 <memmove>
}
 5d8:	60a2                	ld	ra,8(sp)
 5da:	6402                	ld	s0,0(sp)
 5dc:	0141                	addi	sp,sp,16
 5de:	8082                	ret

00000000000005e0 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 5e0:	1141                	addi	sp,sp,-16
 5e2:	e406                	sd	ra,8(sp)
 5e4:	e022                	sd	s0,0(sp)
 5e6:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 5e8:	040007b7          	lui	a5,0x4000
 5ec:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdfdd>
 5ee:	07b2                	slli	a5,a5,0xc
}
 5f0:	4388                	lw	a0,0(a5)
 5f2:	60a2                	ld	ra,8(sp)
 5f4:	6402                	ld	s0,0(sp)
 5f6:	0141                	addi	sp,sp,16
 5f8:	8082                	ret

00000000000005fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5fa:	4885                	li	a7,1
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <exit>:
.global exit
exit:
 li a7, SYS_exit
 602:	4889                	li	a7,2
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <wait>:
.global wait
wait:
 li a7, SYS_wait
 60a:	488d                	li	a7,3
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 612:	4891                	li	a7,4
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <read>:
.global read
read:
 li a7, SYS_read
 61a:	4895                	li	a7,5
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <write>:
.global write
write:
 li a7, SYS_write
 622:	48c1                	li	a7,16
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <close>:
.global close
close:
 li a7, SYS_close
 62a:	48d5                	li	a7,21
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <kill>:
.global kill
kill:
 li a7, SYS_kill
 632:	4899                	li	a7,6
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <exec>:
.global exec
exec:
 li a7, SYS_exec
 63a:	489d                	li	a7,7
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <open>:
.global open
open:
 li a7, SYS_open
 642:	48bd                	li	a7,15
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 64a:	48c5                	li	a7,17
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 652:	48c9                	li	a7,18
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 65a:	48a1                	li	a7,8
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <link>:
.global link
link:
 li a7, SYS_link
 662:	48cd                	li	a7,19
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 66a:	48d1                	li	a7,20
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 672:	48a5                	li	a7,9
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <dup>:
.global dup
dup:
 li a7, SYS_dup
 67a:	48a9                	li	a7,10
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 682:	48ad                	li	a7,11
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 68a:	48b1                	li	a7,12
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 692:	48b5                	li	a7,13
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 69a:	48b9                	li	a7,14
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 6a2:	48f5                	li	a7,29
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 6aa:	48f9                	li	a7,30
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <send>:
.global send
send:
 li a7, SYS_send
 6b2:	48fd                	li	a7,31
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <recv>:
.global recv
recv:
 li a7, SYS_recv
 6ba:	02000893          	li	a7,32
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 6c4:	02100893          	li	a7,33
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 6ce:	02200893          	li	a7,34
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 6d8:	02400893          	li	a7,36
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e2:	1101                	addi	sp,sp,-32
 6e4:	ec06                	sd	ra,24(sp)
 6e6:	e822                	sd	s0,16(sp)
 6e8:	1000                	addi	s0,sp,32
 6ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6ee:	4605                	li	a2,1
 6f0:	fef40593          	addi	a1,s0,-17
 6f4:	f2fff0ef          	jal	622 <write>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6105                	addi	sp,sp,32
 6fe:	8082                	ret

0000000000000700 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 700:	7139                	addi	sp,sp,-64
 702:	fc06                	sd	ra,56(sp)
 704:	f822                	sd	s0,48(sp)
 706:	f426                	sd	s1,40(sp)
 708:	f04a                	sd	s2,32(sp)
 70a:	ec4e                	sd	s3,24(sp)
 70c:	0080                	addi	s0,sp,64
 70e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 710:	c299                	beqz	a3,716 <printint+0x16>
 712:	0605ce63          	bltz	a1,78e <printint+0x8e>
  neg = 0;
 716:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 718:	fc040313          	addi	t1,s0,-64
  neg = 0;
 71c:	869a                	mv	a3,t1
  i = 0;
 71e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 720:	00000817          	auipc	a6,0x0
 724:	71080813          	addi	a6,a6,1808 # e30 <digits>
 728:	88be                	mv	a7,a5
 72a:	0017851b          	addiw	a0,a5,1
 72e:	87aa                	mv	a5,a0
 730:	02c5f73b          	remuw	a4,a1,a2
 734:	1702                	slli	a4,a4,0x20
 736:	9301                	srli	a4,a4,0x20
 738:	9742                	add	a4,a4,a6
 73a:	00074703          	lbu	a4,0(a4)
 73e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 742:	872e                	mv	a4,a1
 744:	02c5d5bb          	divuw	a1,a1,a2
 748:	0685                	addi	a3,a3,1
 74a:	fcc77fe3          	bgeu	a4,a2,728 <printint+0x28>
  if(neg)
 74e:	000e0c63          	beqz	t3,766 <printint+0x66>
    buf[i++] = '-';
 752:	fd050793          	addi	a5,a0,-48
 756:	00878533          	add	a0,a5,s0
 75a:	02d00793          	li	a5,45
 75e:	fef50823          	sb	a5,-16(a0)
 762:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 766:	fff7899b          	addiw	s3,a5,-1
 76a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 76e:	fff4c583          	lbu	a1,-1(s1)
 772:	854a                	mv	a0,s2
 774:	f6fff0ef          	jal	6e2 <putc>
  while(--i >= 0)
 778:	39fd                	addiw	s3,s3,-1 # 1fffff <base+0x1fdfdf>
 77a:	14fd                	addi	s1,s1,-1
 77c:	fe09d9e3          	bgez	s3,76e <printint+0x6e>
}
 780:	70e2                	ld	ra,56(sp)
 782:	7442                	ld	s0,48(sp)
 784:	74a2                	ld	s1,40(sp)
 786:	7902                	ld	s2,32(sp)
 788:	69e2                	ld	s3,24(sp)
 78a:	6121                	addi	sp,sp,64
 78c:	8082                	ret
    x = -xx;
 78e:	40b005bb          	negw	a1,a1
    neg = 1;
 792:	4e05                	li	t3,1
    x = -xx;
 794:	b751                	j	718 <printint+0x18>

0000000000000796 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 796:	711d                	addi	sp,sp,-96
 798:	ec86                	sd	ra,88(sp)
 79a:	e8a2                	sd	s0,80(sp)
 79c:	e4a6                	sd	s1,72(sp)
 79e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7a0:	0005c483          	lbu	s1,0(a1)
 7a4:	26048663          	beqz	s1,a10 <vprintf+0x27a>
 7a8:	e0ca                	sd	s2,64(sp)
 7aa:	fc4e                	sd	s3,56(sp)
 7ac:	f852                	sd	s4,48(sp)
 7ae:	f456                	sd	s5,40(sp)
 7b0:	f05a                	sd	s6,32(sp)
 7b2:	ec5e                	sd	s7,24(sp)
 7b4:	e862                	sd	s8,16(sp)
 7b6:	e466                	sd	s9,8(sp)
 7b8:	8b2a                	mv	s6,a0
 7ba:	8a2e                	mv	s4,a1
 7bc:	8bb2                	mv	s7,a2
  state = 0;
 7be:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7c0:	4901                	li	s2,0
 7c2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7c8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7cc:	06c00c93          	li	s9,108
 7d0:	a00d                	j	7f2 <vprintf+0x5c>
        putc(fd, c0);
 7d2:	85a6                	mv	a1,s1
 7d4:	855a                	mv	a0,s6
 7d6:	f0dff0ef          	jal	6e2 <putc>
 7da:	a019                	j	7e0 <vprintf+0x4a>
    } else if(state == '%'){
 7dc:	03598363          	beq	s3,s5,802 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 7e0:	0019079b          	addiw	a5,s2,1
 7e4:	893e                	mv	s2,a5
 7e6:	873e                	mv	a4,a5
 7e8:	97d2                	add	a5,a5,s4
 7ea:	0007c483          	lbu	s1,0(a5)
 7ee:	20048963          	beqz	s1,a00 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 7f2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 7f6:	fe0993e3          	bnez	s3,7dc <vprintf+0x46>
      if(c0 == '%'){
 7fa:	fd579ce3          	bne	a5,s5,7d2 <vprintf+0x3c>
        state = '%';
 7fe:	89be                	mv	s3,a5
 800:	b7c5                	j	7e0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 802:	00ea06b3          	add	a3,s4,a4
 806:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 80a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 80c:	c681                	beqz	a3,814 <vprintf+0x7e>
 80e:	9752                	add	a4,a4,s4
 810:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 814:	03878e63          	beq	a5,s8,850 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 818:	05978863          	beq	a5,s9,868 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 81c:	07500713          	li	a4,117
 820:	0ee78263          	beq	a5,a4,904 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 824:	07800713          	li	a4,120
 828:	12e78463          	beq	a5,a4,950 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 82c:	07000713          	li	a4,112
 830:	14e78963          	beq	a5,a4,982 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 834:	07300713          	li	a4,115
 838:	18e78863          	beq	a5,a4,9c8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 83c:	02500713          	li	a4,37
 840:	04e79463          	bne	a5,a4,888 <vprintf+0xf2>
        putc(fd, '%');
 844:	85ba                	mv	a1,a4
 846:	855a                	mv	a0,s6
 848:	e9bff0ef          	jal	6e2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 84c:	4981                	li	s3,0
 84e:	bf49                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 850:	008b8493          	addi	s1,s7,8
 854:	4685                	li	a3,1
 856:	4629                	li	a2,10
 858:	000ba583          	lw	a1,0(s7)
 85c:	855a                	mv	a0,s6
 85e:	ea3ff0ef          	jal	700 <printint>
 862:	8ba6                	mv	s7,s1
      state = 0;
 864:	4981                	li	s3,0
 866:	bfad                	j	7e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 868:	06400793          	li	a5,100
 86c:	02f68963          	beq	a3,a5,89e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 870:	06c00793          	li	a5,108
 874:	04f68263          	beq	a3,a5,8b8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 878:	07500793          	li	a5,117
 87c:	0af68063          	beq	a3,a5,91c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 880:	07800793          	li	a5,120
 884:	0ef68263          	beq	a3,a5,968 <vprintf+0x1d2>
        putc(fd, '%');
 888:	02500593          	li	a1,37
 88c:	855a                	mv	a0,s6
 88e:	e55ff0ef          	jal	6e2 <putc>
        putc(fd, c0);
 892:	85a6                	mv	a1,s1
 894:	855a                	mv	a0,s6
 896:	e4dff0ef          	jal	6e2 <putc>
      state = 0;
 89a:	4981                	li	s3,0
 89c:	b791                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 89e:	008b8493          	addi	s1,s7,8
 8a2:	4685                	li	a3,1
 8a4:	4629                	li	a2,10
 8a6:	000ba583          	lw	a1,0(s7)
 8aa:	855a                	mv	a0,s6
 8ac:	e55ff0ef          	jal	700 <printint>
        i += 1;
 8b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8b2:	8ba6                	mv	s7,s1
      state = 0;
 8b4:	4981                	li	s3,0
        i += 1;
 8b6:	b72d                	j	7e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8b8:	06400793          	li	a5,100
 8bc:	02f60763          	beq	a2,a5,8ea <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8c0:	07500793          	li	a5,117
 8c4:	06f60963          	beq	a2,a5,936 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8c8:	07800793          	li	a5,120
 8cc:	faf61ee3          	bne	a2,a5,888 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d0:	008b8493          	addi	s1,s7,8
 8d4:	4681                	li	a3,0
 8d6:	4641                	li	a2,16
 8d8:	000ba583          	lw	a1,0(s7)
 8dc:	855a                	mv	a0,s6
 8de:	e23ff0ef          	jal	700 <printint>
        i += 2;
 8e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8e4:	8ba6                	mv	s7,s1
      state = 0;
 8e6:	4981                	li	s3,0
        i += 2;
 8e8:	bde5                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ea:	008b8493          	addi	s1,s7,8
 8ee:	4685                	li	a3,1
 8f0:	4629                	li	a2,10
 8f2:	000ba583          	lw	a1,0(s7)
 8f6:	855a                	mv	a0,s6
 8f8:	e09ff0ef          	jal	700 <printint>
        i += 2;
 8fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8fe:	8ba6                	mv	s7,s1
      state = 0;
 900:	4981                	li	s3,0
        i += 2;
 902:	bdf9                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 904:	008b8493          	addi	s1,s7,8
 908:	4681                	li	a3,0
 90a:	4629                	li	a2,10
 90c:	000ba583          	lw	a1,0(s7)
 910:	855a                	mv	a0,s6
 912:	defff0ef          	jal	700 <printint>
 916:	8ba6                	mv	s7,s1
      state = 0;
 918:	4981                	li	s3,0
 91a:	b5d9                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 91c:	008b8493          	addi	s1,s7,8
 920:	4681                	li	a3,0
 922:	4629                	li	a2,10
 924:	000ba583          	lw	a1,0(s7)
 928:	855a                	mv	a0,s6
 92a:	dd7ff0ef          	jal	700 <printint>
        i += 1;
 92e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 930:	8ba6                	mv	s7,s1
      state = 0;
 932:	4981                	li	s3,0
        i += 1;
 934:	b575                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 936:	008b8493          	addi	s1,s7,8
 93a:	4681                	li	a3,0
 93c:	4629                	li	a2,10
 93e:	000ba583          	lw	a1,0(s7)
 942:	855a                	mv	a0,s6
 944:	dbdff0ef          	jal	700 <printint>
        i += 2;
 948:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 94a:	8ba6                	mv	s7,s1
      state = 0;
 94c:	4981                	li	s3,0
        i += 2;
 94e:	bd49                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 950:	008b8493          	addi	s1,s7,8
 954:	4681                	li	a3,0
 956:	4641                	li	a2,16
 958:	000ba583          	lw	a1,0(s7)
 95c:	855a                	mv	a0,s6
 95e:	da3ff0ef          	jal	700 <printint>
 962:	8ba6                	mv	s7,s1
      state = 0;
 964:	4981                	li	s3,0
 966:	bdad                	j	7e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 968:	008b8493          	addi	s1,s7,8
 96c:	4681                	li	a3,0
 96e:	4641                	li	a2,16
 970:	000ba583          	lw	a1,0(s7)
 974:	855a                	mv	a0,s6
 976:	d8bff0ef          	jal	700 <printint>
        i += 1;
 97a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 97c:	8ba6                	mv	s7,s1
      state = 0;
 97e:	4981                	li	s3,0
        i += 1;
 980:	b585                	j	7e0 <vprintf+0x4a>
 982:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 984:	008b8d13          	addi	s10,s7,8
 988:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 98c:	03000593          	li	a1,48
 990:	855a                	mv	a0,s6
 992:	d51ff0ef          	jal	6e2 <putc>
  putc(fd, 'x');
 996:	07800593          	li	a1,120
 99a:	855a                	mv	a0,s6
 99c:	d47ff0ef          	jal	6e2 <putc>
 9a0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9a2:	00000b97          	auipc	s7,0x0
 9a6:	48eb8b93          	addi	s7,s7,1166 # e30 <digits>
 9aa:	03c9d793          	srli	a5,s3,0x3c
 9ae:	97de                	add	a5,a5,s7
 9b0:	0007c583          	lbu	a1,0(a5)
 9b4:	855a                	mv	a0,s6
 9b6:	d2dff0ef          	jal	6e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9ba:	0992                	slli	s3,s3,0x4
 9bc:	34fd                	addiw	s1,s1,-1
 9be:	f4f5                	bnez	s1,9aa <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9c0:	8bea                	mv	s7,s10
      state = 0;
 9c2:	4981                	li	s3,0
 9c4:	6d02                	ld	s10,0(sp)
 9c6:	bd29                	j	7e0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9c8:	008b8993          	addi	s3,s7,8
 9cc:	000bb483          	ld	s1,0(s7)
 9d0:	cc91                	beqz	s1,9ec <vprintf+0x256>
        for(; *s; s++)
 9d2:	0004c583          	lbu	a1,0(s1)
 9d6:	c195                	beqz	a1,9fa <vprintf+0x264>
          putc(fd, *s);
 9d8:	855a                	mv	a0,s6
 9da:	d09ff0ef          	jal	6e2 <putc>
        for(; *s; s++)
 9de:	0485                	addi	s1,s1,1
 9e0:	0004c583          	lbu	a1,0(s1)
 9e4:	f9f5                	bnez	a1,9d8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 9e6:	8bce                	mv	s7,s3
      state = 0;
 9e8:	4981                	li	s3,0
 9ea:	bbdd                	j	7e0 <vprintf+0x4a>
          s = "(null)";
 9ec:	00000497          	auipc	s1,0x0
 9f0:	43c48493          	addi	s1,s1,1084 # e28 <malloc+0x32c>
        for(; *s; s++)
 9f4:	02800593          	li	a1,40
 9f8:	b7c5                	j	9d8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 9fa:	8bce                	mv	s7,s3
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	b3cd                	j	7e0 <vprintf+0x4a>
 a00:	6906                	ld	s2,64(sp)
 a02:	79e2                	ld	s3,56(sp)
 a04:	7a42                	ld	s4,48(sp)
 a06:	7aa2                	ld	s5,40(sp)
 a08:	7b02                	ld	s6,32(sp)
 a0a:	6be2                	ld	s7,24(sp)
 a0c:	6c42                	ld	s8,16(sp)
 a0e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a10:	60e6                	ld	ra,88(sp)
 a12:	6446                	ld	s0,80(sp)
 a14:	64a6                	ld	s1,72(sp)
 a16:	6125                	addi	sp,sp,96
 a18:	8082                	ret

0000000000000a1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1a:	715d                	addi	sp,sp,-80
 a1c:	ec06                	sd	ra,24(sp)
 a1e:	e822                	sd	s0,16(sp)
 a20:	1000                	addi	s0,sp,32
 a22:	e010                	sd	a2,0(s0)
 a24:	e414                	sd	a3,8(s0)
 a26:	e818                	sd	a4,16(s0)
 a28:	ec1c                	sd	a5,24(s0)
 a2a:	03043023          	sd	a6,32(s0)
 a2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a32:	8622                	mv	a2,s0
 a34:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a38:	d5fff0ef          	jal	796 <vprintf>
}
 a3c:	60e2                	ld	ra,24(sp)
 a3e:	6442                	ld	s0,16(sp)
 a40:	6161                	addi	sp,sp,80
 a42:	8082                	ret

0000000000000a44 <printf>:

void
printf(const char *fmt, ...)
{
 a44:	711d                	addi	sp,sp,-96
 a46:	ec06                	sd	ra,24(sp)
 a48:	e822                	sd	s0,16(sp)
 a4a:	1000                	addi	s0,sp,32
 a4c:	e40c                	sd	a1,8(s0)
 a4e:	e810                	sd	a2,16(s0)
 a50:	ec14                	sd	a3,24(s0)
 a52:	f018                	sd	a4,32(s0)
 a54:	f41c                	sd	a5,40(s0)
 a56:	03043823          	sd	a6,48(s0)
 a5a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a5e:	00840613          	addi	a2,s0,8
 a62:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a66:	85aa                	mv	a1,a0
 a68:	4505                	li	a0,1
 a6a:	d2dff0ef          	jal	796 <vprintf>
}
 a6e:	60e2                	ld	ra,24(sp)
 a70:	6442                	ld	s0,16(sp)
 a72:	6125                	addi	sp,sp,96
 a74:	8082                	ret

0000000000000a76 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a76:	1141                	addi	sp,sp,-16
 a78:	e406                	sd	ra,8(sp)
 a7a:	e022                	sd	s0,0(sp)
 a7c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a7e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a82:	00001797          	auipc	a5,0x1
 a86:	58e7b783          	ld	a5,1422(a5) # 2010 <freep>
 a8a:	a02d                	j	ab4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a8c:	4618                	lw	a4,8(a2)
 a8e:	9f2d                	addw	a4,a4,a1
 a90:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a94:	6398                	ld	a4,0(a5)
 a96:	6310                	ld	a2,0(a4)
 a98:	a83d                	j	ad6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a9a:	ff852703          	lw	a4,-8(a0)
 a9e:	9f31                	addw	a4,a4,a2
 aa0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aa2:	ff053683          	ld	a3,-16(a0)
 aa6:	a091                	j	aea <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa8:	6398                	ld	a4,0(a5)
 aaa:	00e7e463          	bltu	a5,a4,ab2 <free+0x3c>
 aae:	00e6ea63          	bltu	a3,a4,ac2 <free+0x4c>
{
 ab2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab4:	fed7fae3          	bgeu	a5,a3,aa8 <free+0x32>
 ab8:	6398                	ld	a4,0(a5)
 aba:	00e6e463          	bltu	a3,a4,ac2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abe:	fee7eae3          	bltu	a5,a4,ab2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 ac2:	ff852583          	lw	a1,-8(a0)
 ac6:	6390                	ld	a2,0(a5)
 ac8:	02059813          	slli	a6,a1,0x20
 acc:	01c85713          	srli	a4,a6,0x1c
 ad0:	9736                	add	a4,a4,a3
 ad2:	fae60de3          	beq	a2,a4,a8c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ada:	4790                	lw	a2,8(a5)
 adc:	02061593          	slli	a1,a2,0x20
 ae0:	01c5d713          	srli	a4,a1,0x1c
 ae4:	973e                	add	a4,a4,a5
 ae6:	fae68ae3          	beq	a3,a4,a9a <free+0x24>
    p->s.ptr = bp->s.ptr;
 aea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aec:	00001717          	auipc	a4,0x1
 af0:	52f73223          	sd	a5,1316(a4) # 2010 <freep>
}
 af4:	60a2                	ld	ra,8(sp)
 af6:	6402                	ld	s0,0(sp)
 af8:	0141                	addi	sp,sp,16
 afa:	8082                	ret

0000000000000afc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 afc:	7139                	addi	sp,sp,-64
 afe:	fc06                	sd	ra,56(sp)
 b00:	f822                	sd	s0,48(sp)
 b02:	f04a                	sd	s2,32(sp)
 b04:	ec4e                	sd	s3,24(sp)
 b06:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b08:	02051993          	slli	s3,a0,0x20
 b0c:	0209d993          	srli	s3,s3,0x20
 b10:	09bd                	addi	s3,s3,15
 b12:	0049d993          	srli	s3,s3,0x4
 b16:	2985                	addiw	s3,s3,1
 b18:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 b1a:	00001517          	auipc	a0,0x1
 b1e:	4f653503          	ld	a0,1270(a0) # 2010 <freep>
 b22:	c905                	beqz	a0,b52 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b26:	4798                	lw	a4,8(a5)
 b28:	09377663          	bgeu	a4,s3,bb4 <malloc+0xb8>
 b2c:	f426                	sd	s1,40(sp)
 b2e:	e852                	sd	s4,16(sp)
 b30:	e456                	sd	s5,8(sp)
 b32:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b34:	8a4e                	mv	s4,s3
 b36:	6705                	lui	a4,0x1
 b38:	00e9f363          	bgeu	s3,a4,b3e <malloc+0x42>
 b3c:	6a05                	lui	s4,0x1
 b3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b46:	00001497          	auipc	s1,0x1
 b4a:	4ca48493          	addi	s1,s1,1226 # 2010 <freep>
  if(p == (char*)-1)
 b4e:	5afd                	li	s5,-1
 b50:	a83d                	j	b8e <malloc+0x92>
 b52:	f426                	sd	s1,40(sp)
 b54:	e852                	sd	s4,16(sp)
 b56:	e456                	sd	s5,8(sp)
 b58:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b5a:	00001797          	auipc	a5,0x1
 b5e:	4c678793          	addi	a5,a5,1222 # 2020 <base>
 b62:	00001717          	auipc	a4,0x1
 b66:	4af73723          	sd	a5,1198(a4) # 2010 <freep>
 b6a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b6c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b70:	b7d1                	j	b34 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b72:	6398                	ld	a4,0(a5)
 b74:	e118                	sd	a4,0(a0)
 b76:	a899                	j	bcc <malloc+0xd0>
  hp->s.size = nu;
 b78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b7c:	0541                	addi	a0,a0,16
 b7e:	ef9ff0ef          	jal	a76 <free>
  return freep;
 b82:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b84:	c125                	beqz	a0,be4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b86:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b88:	4798                	lw	a4,8(a5)
 b8a:	03277163          	bgeu	a4,s2,bac <malloc+0xb0>
    if(p == freep)
 b8e:	6098                	ld	a4,0(s1)
 b90:	853e                	mv	a0,a5
 b92:	fef71ae3          	bne	a4,a5,b86 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b96:	8552                	mv	a0,s4
 b98:	af3ff0ef          	jal	68a <sbrk>
  if(p == (char*)-1)
 b9c:	fd551ee3          	bne	a0,s5,b78 <malloc+0x7c>
        return 0;
 ba0:	4501                	li	a0,0
 ba2:	74a2                	ld	s1,40(sp)
 ba4:	6a42                	ld	s4,16(sp)
 ba6:	6aa2                	ld	s5,8(sp)
 ba8:	6b02                	ld	s6,0(sp)
 baa:	a03d                	j	bd8 <malloc+0xdc>
 bac:	74a2                	ld	s1,40(sp)
 bae:	6a42                	ld	s4,16(sp)
 bb0:	6aa2                	ld	s5,8(sp)
 bb2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bb4:	fae90fe3          	beq	s2,a4,b72 <malloc+0x76>
        p->s.size -= nunits;
 bb8:	4137073b          	subw	a4,a4,s3
 bbc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bbe:	02071693          	slli	a3,a4,0x20
 bc2:	01c6d713          	srli	a4,a3,0x1c
 bc6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bc8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bcc:	00001717          	auipc	a4,0x1
 bd0:	44a73223          	sd	a0,1092(a4) # 2010 <freep>
      return (void*)(p + 1);
 bd4:	01078513          	addi	a0,a5,16
  }
}
 bd8:	70e2                	ld	ra,56(sp)
 bda:	7442                	ld	s0,48(sp)
 bdc:	7902                	ld	s2,32(sp)
 bde:	69e2                	ld	s3,24(sp)
 be0:	6121                	addi	sp,sp,64
 be2:	8082                	ret
 be4:	74a2                	ld	s1,40(sp)
 be6:	6a42                	ld	s4,16(sp)
 be8:	6aa2                	ld	s5,8(sp)
 bea:	6b02                	ld	s6,0(sp)
 bec:	b7f5                	j	bd8 <malloc+0xdc>
