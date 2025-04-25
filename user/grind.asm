
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	40b000ef          	jal	cc2 <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	17050513          	addi	a0,a0,368 # 1230 <malloc+0xfc>
      c8:	3db000ef          	jal	ca2 <mkdir>
  if(chdir("grindir") != 0){
      cc:	00001517          	auipc	a0,0x1
      d0:	16450513          	addi	a0,a0,356 # 1230 <malloc+0xfc>
      d4:	3d7000ef          	jal	caa <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	14a50513          	addi	a0,a0,330 # 1238 <malloc+0x104>
      f6:	787000ef          	jal	107c <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	33f000ef          	jal	c3a <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	14c50513          	addi	a0,a0,332 # 1260 <malloc+0x12c>
     11c:	38f000ef          	jal	caa <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	150c0c13          	addi	s8,s8,336 # 1270 <malloc+0x13c>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	13ec0c13          	addi	s8,s8,318 # 1268 <malloc+0x134>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     136:	e353f7b7          	lui	a5,0xe353f
     13a:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353d3c7>
     13e:	20c4a9b7          	lui	s3,0x20c4a
     142:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c4779e>
     146:	1982                	slli	s3,s3,0x20
     148:	99be                	add	s3,s3,a5
     14a:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     14e:	4b85                	li	s7,1
    int what = rand() % 23;
     150:	b2164a37          	lui	s4,0xb2164
     154:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     158:	4ad9                	li	s5,22
     15a:	00001917          	auipc	s2,0x1
     15e:	3e690913          	addi	s2,s2,998 # 1540 <malloc+0x40c>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     162:	f6840d93          	addi	s11,s0,-152
     166:	a819                	j	17c <go+0xd2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     168:	20200593          	li	a1,514
     16c:	00001517          	auipc	a0,0x1
     170:	10c50513          	addi	a0,a0,268 # 1278 <malloc+0x144>
     174:	307000ef          	jal	c7a <open>
     178:	2eb000ef          	jal	c62 <close>
    iters++;
     17c:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     17e:	0024d793          	srli	a5,s1,0x2
     182:	0337b7b3          	mulhu	a5,a5,s3
     186:	8391                	srli	a5,a5,0x4
     188:	036787b3          	mul	a5,a5,s6
     18c:	00f49763          	bne	s1,a5,19a <go+0xf0>
      write(1, which_child?"B":"A", 1);
     190:	865e                	mv	a2,s7
     192:	85e2                	mv	a1,s8
     194:	855e                	mv	a0,s7
     196:	2c5000ef          	jal	c5a <write>
    int what = rand() % 23;
     19a:	ef5ff0ef          	jal	8e <rand>
     19e:	034507b3          	mul	a5,a0,s4
     1a2:	9381                	srli	a5,a5,0x20
     1a4:	9fa9                	addw	a5,a5,a0
     1a6:	4047d79b          	sraiw	a5,a5,0x4
     1aa:	41f5571b          	sraiw	a4,a0,0x1f
     1ae:	9f99                	subw	a5,a5,a4
     1b0:	0017971b          	slliw	a4,a5,0x1
     1b4:	9f3d                	addw	a4,a4,a5
     1b6:	0037171b          	slliw	a4,a4,0x3
     1ba:	40f707bb          	subw	a5,a4,a5
     1be:	9d1d                	subw	a0,a0,a5
     1c0:	faaaeee3          	bltu	s5,a0,17c <go+0xd2>
     1c4:	02051793          	slli	a5,a0,0x20
     1c8:	01e7d513          	srli	a0,a5,0x1e
     1cc:	954a                	add	a0,a0,s2
     1ce:	411c                	lw	a5,0(a0)
     1d0:	97ca                	add	a5,a5,s2
     1d2:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1d4:	20200593          	li	a1,514
     1d8:	00001517          	auipc	a0,0x1
     1dc:	0b050513          	addi	a0,a0,176 # 1288 <malloc+0x154>
     1e0:	29b000ef          	jal	c7a <open>
     1e4:	27f000ef          	jal	c62 <close>
     1e8:	bf51                	j	17c <go+0xd2>
      unlink("grindir/../a");
     1ea:	00001517          	auipc	a0,0x1
     1ee:	08e50513          	addi	a0,a0,142 # 1278 <malloc+0x144>
     1f2:	299000ef          	jal	c8a <unlink>
     1f6:	b759                	j	17c <go+0xd2>
      if(chdir("grindir") != 0){
     1f8:	00001517          	auipc	a0,0x1
     1fc:	03850513          	addi	a0,a0,56 # 1230 <malloc+0xfc>
     200:	2ab000ef          	jal	caa <chdir>
     204:	ed11                	bnez	a0,220 <go+0x176>
      unlink("../b");
     206:	00001517          	auipc	a0,0x1
     20a:	09a50513          	addi	a0,a0,154 # 12a0 <malloc+0x16c>
     20e:	27d000ef          	jal	c8a <unlink>
      chdir("/");
     212:	00001517          	auipc	a0,0x1
     216:	04e50513          	addi	a0,a0,78 # 1260 <malloc+0x12c>
     21a:	291000ef          	jal	caa <chdir>
     21e:	bfb9                	j	17c <go+0xd2>
        printf("grind: chdir grindir failed\n");
     220:	00001517          	auipc	a0,0x1
     224:	01850513          	addi	a0,a0,24 # 1238 <malloc+0x104>
     228:	655000ef          	jal	107c <printf>
        exit(1);
     22c:	4505                	li	a0,1
     22e:	20d000ef          	jal	c3a <exit>
      close(fd);
     232:	8566                	mv	a0,s9
     234:	22f000ef          	jal	c62 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	06c50513          	addi	a0,a0,108 # 12a8 <malloc+0x174>
     244:	237000ef          	jal	c7a <open>
     248:	8caa                	mv	s9,a0
     24a:	bf0d                	j	17c <go+0xd2>
      close(fd);
     24c:	8566                	mv	a0,s9
     24e:	215000ef          	jal	c62 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     252:	20200593          	li	a1,514
     256:	00001517          	auipc	a0,0x1
     25a:	06250513          	addi	a0,a0,98 # 12b8 <malloc+0x184>
     25e:	21d000ef          	jal	c7a <open>
     262:	8caa                	mv	s9,a0
     264:	bf21                	j	17c <go+0xd2>
      write(fd, buf, sizeof(buf));
     266:	3e700613          	li	a2,999
     26a:	00002597          	auipc	a1,0x2
     26e:	db658593          	addi	a1,a1,-586 # 2020 <buf.0>
     272:	8566                	mv	a0,s9
     274:	1e7000ef          	jal	c5a <write>
     278:	b711                	j	17c <go+0xd2>
      read(fd, buf, sizeof(buf));
     27a:	3e700613          	li	a2,999
     27e:	00002597          	auipc	a1,0x2
     282:	da258593          	addi	a1,a1,-606 # 2020 <buf.0>
     286:	8566                	mv	a0,s9
     288:	1cb000ef          	jal	c52 <read>
     28c:	bdc5                	j	17c <go+0xd2>
      mkdir("grindir/../a");
     28e:	00001517          	auipc	a0,0x1
     292:	fea50513          	addi	a0,a0,-22 # 1278 <malloc+0x144>
     296:	20d000ef          	jal	ca2 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     29a:	20200593          	li	a1,514
     29e:	00001517          	auipc	a0,0x1
     2a2:	03250513          	addi	a0,a0,50 # 12d0 <malloc+0x19c>
     2a6:	1d5000ef          	jal	c7a <open>
     2aa:	1b9000ef          	jal	c62 <close>
      unlink("a/a");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	03250513          	addi	a0,a0,50 # 12e0 <malloc+0x1ac>
     2b6:	1d5000ef          	jal	c8a <unlink>
     2ba:	b5c9                	j	17c <go+0xd2>
      mkdir("/../b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	02c50513          	addi	a0,a0,44 # 12e8 <malloc+0x1b4>
     2c4:	1df000ef          	jal	ca2 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2c8:	20200593          	li	a1,514
     2cc:	00001517          	auipc	a0,0x1
     2d0:	02450513          	addi	a0,a0,36 # 12f0 <malloc+0x1bc>
     2d4:	1a7000ef          	jal	c7a <open>
     2d8:	18b000ef          	jal	c62 <close>
      unlink("b/b");
     2dc:	00001517          	auipc	a0,0x1
     2e0:	02450513          	addi	a0,a0,36 # 1300 <malloc+0x1cc>
     2e4:	1a7000ef          	jal	c8a <unlink>
     2e8:	bd51                	j	17c <go+0xd2>
      unlink("b");
     2ea:	00001517          	auipc	a0,0x1
     2ee:	01e50513          	addi	a0,a0,30 # 1308 <malloc+0x1d4>
     2f2:	199000ef          	jal	c8a <unlink>
      link("../grindir/./../a", "../b");
     2f6:	00001597          	auipc	a1,0x1
     2fa:	faa58593          	addi	a1,a1,-86 # 12a0 <malloc+0x16c>
     2fe:	00001517          	auipc	a0,0x1
     302:	01250513          	addi	a0,a0,18 # 1310 <malloc+0x1dc>
     306:	195000ef          	jal	c9a <link>
     30a:	bd8d                	j	17c <go+0xd2>
      unlink("../grindir/../a");
     30c:	00001517          	auipc	a0,0x1
     310:	01c50513          	addi	a0,a0,28 # 1328 <malloc+0x1f4>
     314:	177000ef          	jal	c8a <unlink>
      link(".././b", "/grindir/../a");
     318:	00001597          	auipc	a1,0x1
     31c:	f9058593          	addi	a1,a1,-112 # 12a8 <malloc+0x174>
     320:	00001517          	auipc	a0,0x1
     324:	01850513          	addi	a0,a0,24 # 1338 <malloc+0x204>
     328:	173000ef          	jal	c9a <link>
     32c:	bd81                	j	17c <go+0xd2>
      int pid = fork();
     32e:	105000ef          	jal	c32 <fork>
      if(pid == 0){
     332:	c519                	beqz	a0,340 <go+0x296>
      } else if(pid < 0){
     334:	00054863          	bltz	a0,344 <go+0x29a>
      wait(0);
     338:	4501                	li	a0,0
     33a:	109000ef          	jal	c42 <wait>
     33e:	bd3d                	j	17c <go+0xd2>
        exit(0);
     340:	0fb000ef          	jal	c3a <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	ffc50513          	addi	a0,a0,-4 # 1340 <malloc+0x20c>
     34c:	531000ef          	jal	107c <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	0e9000ef          	jal	c3a <exit>
      int pid = fork();
     356:	0dd000ef          	jal	c32 <fork>
      if(pid == 0){
     35a:	c519                	beqz	a0,368 <go+0x2be>
      } else if(pid < 0){
     35c:	00054d63          	bltz	a0,376 <go+0x2cc>
      wait(0);
     360:	4501                	li	a0,0
     362:	0e1000ef          	jal	c42 <wait>
     366:	bd19                	j	17c <go+0xd2>
        fork();
     368:	0cb000ef          	jal	c32 <fork>
        fork();
     36c:	0c7000ef          	jal	c32 <fork>
        exit(0);
     370:	4501                	li	a0,0
     372:	0c9000ef          	jal	c3a <exit>
        printf("grind: fork failed\n");
     376:	00001517          	auipc	a0,0x1
     37a:	fca50513          	addi	a0,a0,-54 # 1340 <malloc+0x20c>
     37e:	4ff000ef          	jal	107c <printf>
        exit(1);
     382:	4505                	li	a0,1
     384:	0b7000ef          	jal	c3a <exit>
      sbrk(6011);
     388:	6505                	lui	a0,0x1
     38a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x1db>
     38e:	135000ef          	jal	cc2 <sbrk>
     392:	b3ed                	j	17c <go+0xd2>
      if(sbrk(0) > break0)
     394:	4501                	li	a0,0
     396:	12d000ef          	jal	cc2 <sbrk>
     39a:	f5843783          	ld	a5,-168(s0)
     39e:	dca7ffe3          	bgeu	a5,a0,17c <go+0xd2>
        sbrk(-(sbrk(0) - break0));
     3a2:	4501                	li	a0,0
     3a4:	11f000ef          	jal	cc2 <sbrk>
     3a8:	f5843783          	ld	a5,-168(s0)
     3ac:	40a7853b          	subw	a0,a5,a0
     3b0:	113000ef          	jal	cc2 <sbrk>
     3b4:	b3e1                	j	17c <go+0xd2>
      int pid = fork();
     3b6:	07d000ef          	jal	c32 <fork>
     3ba:	8d2a                	mv	s10,a0
      if(pid == 0){
     3bc:	c10d                	beqz	a0,3de <go+0x334>
      } else if(pid < 0){
     3be:	02054d63          	bltz	a0,3f8 <go+0x34e>
      if(chdir("../grindir/..") != 0){
     3c2:	00001517          	auipc	a0,0x1
     3c6:	f9e50513          	addi	a0,a0,-98 # 1360 <malloc+0x22c>
     3ca:	0e1000ef          	jal	caa <chdir>
     3ce:	ed15                	bnez	a0,40a <go+0x360>
      kill(pid);
     3d0:	856a                	mv	a0,s10
     3d2:	099000ef          	jal	c6a <kill>
      wait(0);
     3d6:	4501                	li	a0,0
     3d8:	06b000ef          	jal	c42 <wait>
     3dc:	b345                	j	17c <go+0xd2>
        close(open("a", O_CREATE|O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	f7650513          	addi	a0,a0,-138 # 1358 <malloc+0x224>
     3ea:	091000ef          	jal	c7a <open>
     3ee:	075000ef          	jal	c62 <close>
        exit(0);
     3f2:	4501                	li	a0,0
     3f4:	047000ef          	jal	c3a <exit>
        printf("grind: fork failed\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	f4850513          	addi	a0,a0,-184 # 1340 <malloc+0x20c>
     400:	47d000ef          	jal	107c <printf>
        exit(1);
     404:	4505                	li	a0,1
     406:	035000ef          	jal	c3a <exit>
        printf("grind: chdir failed\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	f6650513          	addi	a0,a0,-154 # 1370 <malloc+0x23c>
     412:	46b000ef          	jal	107c <printf>
        exit(1);
     416:	4505                	li	a0,1
     418:	023000ef          	jal	c3a <exit>
      int pid = fork();
     41c:	017000ef          	jal	c32 <fork>
      if(pid == 0){
     420:	c519                	beqz	a0,42e <go+0x384>
      } else if(pid < 0){
     422:	00054d63          	bltz	a0,43c <go+0x392>
      wait(0);
     426:	4501                	li	a0,0
     428:	01b000ef          	jal	c42 <wait>
     42c:	bb81                	j	17c <go+0xd2>
        kill(getpid());
     42e:	08d000ef          	jal	cba <getpid>
     432:	039000ef          	jal	c6a <kill>
        exit(0);
     436:	4501                	li	a0,0
     438:	003000ef          	jal	c3a <exit>
        printf("grind: fork failed\n");
     43c:	00001517          	auipc	a0,0x1
     440:	f0450513          	addi	a0,a0,-252 # 1340 <malloc+0x20c>
     444:	439000ef          	jal	107c <printf>
        exit(1);
     448:	4505                	li	a0,1
     44a:	7f0000ef          	jal	c3a <exit>
      if(pipe(fds) < 0){
     44e:	f7840513          	addi	a0,s0,-136
     452:	7f8000ef          	jal	c4a <pipe>
     456:	02054363          	bltz	a0,47c <go+0x3d2>
      int pid = fork();
     45a:	7d8000ef          	jal	c32 <fork>
      if(pid == 0){
     45e:	c905                	beqz	a0,48e <go+0x3e4>
      } else if(pid < 0){
     460:	08054263          	bltz	a0,4e4 <go+0x43a>
      close(fds[0]);
     464:	f7842503          	lw	a0,-136(s0)
     468:	7fa000ef          	jal	c62 <close>
      close(fds[1]);
     46c:	f7c42503          	lw	a0,-132(s0)
     470:	7f2000ef          	jal	c62 <close>
      wait(0);
     474:	4501                	li	a0,0
     476:	7cc000ef          	jal	c42 <wait>
     47a:	b309                	j	17c <go+0xd2>
        printf("grind: pipe failed\n");
     47c:	00001517          	auipc	a0,0x1
     480:	f0c50513          	addi	a0,a0,-244 # 1388 <malloc+0x254>
     484:	3f9000ef          	jal	107c <printf>
        exit(1);
     488:	4505                	li	a0,1
     48a:	7b0000ef          	jal	c3a <exit>
        fork();
     48e:	7a4000ef          	jal	c32 <fork>
        fork();
     492:	7a0000ef          	jal	c32 <fork>
        if(write(fds[1], "x", 1) != 1)
     496:	4605                	li	a2,1
     498:	00001597          	auipc	a1,0x1
     49c:	f0858593          	addi	a1,a1,-248 # 13a0 <malloc+0x26c>
     4a0:	f7c42503          	lw	a0,-132(s0)
     4a4:	7b6000ef          	jal	c5a <write>
     4a8:	4785                	li	a5,1
     4aa:	00f51f63          	bne	a0,a5,4c8 <go+0x41e>
        if(read(fds[0], &c, 1) != 1)
     4ae:	4605                	li	a2,1
     4b0:	f7040593          	addi	a1,s0,-144
     4b4:	f7842503          	lw	a0,-136(s0)
     4b8:	79a000ef          	jal	c52 <read>
     4bc:	4785                	li	a5,1
     4be:	00f51c63          	bne	a0,a5,4d6 <go+0x42c>
        exit(0);
     4c2:	4501                	li	a0,0
     4c4:	776000ef          	jal	c3a <exit>
          printf("grind: pipe write failed\n");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	ee050513          	addi	a0,a0,-288 # 13a8 <malloc+0x274>
     4d0:	3ad000ef          	jal	107c <printf>
     4d4:	bfe9                	j	4ae <go+0x404>
          printf("grind: pipe read failed\n");
     4d6:	00001517          	auipc	a0,0x1
     4da:	ef250513          	addi	a0,a0,-270 # 13c8 <malloc+0x294>
     4de:	39f000ef          	jal	107c <printf>
     4e2:	b7c5                	j	4c2 <go+0x418>
        printf("grind: fork failed\n");
     4e4:	00001517          	auipc	a0,0x1
     4e8:	e5c50513          	addi	a0,a0,-420 # 1340 <malloc+0x20c>
     4ec:	391000ef          	jal	107c <printf>
        exit(1);
     4f0:	4505                	li	a0,1
     4f2:	748000ef          	jal	c3a <exit>
      int pid = fork();
     4f6:	73c000ef          	jal	c32 <fork>
      if(pid == 0){
     4fa:	c519                	beqz	a0,508 <go+0x45e>
      } else if(pid < 0){
     4fc:	04054f63          	bltz	a0,55a <go+0x4b0>
      wait(0);
     500:	4501                	li	a0,0
     502:	740000ef          	jal	c42 <wait>
     506:	b99d                	j	17c <go+0xd2>
        unlink("a");
     508:	00001517          	auipc	a0,0x1
     50c:	e5050513          	addi	a0,a0,-432 # 1358 <malloc+0x224>
     510:	77a000ef          	jal	c8a <unlink>
        mkdir("a");
     514:	00001517          	auipc	a0,0x1
     518:	e4450513          	addi	a0,a0,-444 # 1358 <malloc+0x224>
     51c:	786000ef          	jal	ca2 <mkdir>
        chdir("a");
     520:	00001517          	auipc	a0,0x1
     524:	e3850513          	addi	a0,a0,-456 # 1358 <malloc+0x224>
     528:	782000ef          	jal	caa <chdir>
        unlink("../a");
     52c:	00001517          	auipc	a0,0x1
     530:	ebc50513          	addi	a0,a0,-324 # 13e8 <malloc+0x2b4>
     534:	756000ef          	jal	c8a <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     538:	20200593          	li	a1,514
     53c:	00001517          	auipc	a0,0x1
     540:	e6450513          	addi	a0,a0,-412 # 13a0 <malloc+0x26c>
     544:	736000ef          	jal	c7a <open>
        unlink("x");
     548:	00001517          	auipc	a0,0x1
     54c:	e5850513          	addi	a0,a0,-424 # 13a0 <malloc+0x26c>
     550:	73a000ef          	jal	c8a <unlink>
        exit(0);
     554:	4501                	li	a0,0
     556:	6e4000ef          	jal	c3a <exit>
        printf("grind: fork failed\n");
     55a:	00001517          	auipc	a0,0x1
     55e:	de650513          	addi	a0,a0,-538 # 1340 <malloc+0x20c>
     562:	31b000ef          	jal	107c <printf>
        exit(1);
     566:	4505                	li	a0,1
     568:	6d2000ef          	jal	c3a <exit>
      unlink("c");
     56c:	00001517          	auipc	a0,0x1
     570:	e8450513          	addi	a0,a0,-380 # 13f0 <malloc+0x2bc>
     574:	716000ef          	jal	c8a <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     578:	20200593          	li	a1,514
     57c:	00001517          	auipc	a0,0x1
     580:	e7450513          	addi	a0,a0,-396 # 13f0 <malloc+0x2bc>
     584:	6f6000ef          	jal	c7a <open>
     588:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     58a:	04054563          	bltz	a0,5d4 <go+0x52a>
      if(write(fd1, "x", 1) != 1){
     58e:	865e                	mv	a2,s7
     590:	00001597          	auipc	a1,0x1
     594:	e1058593          	addi	a1,a1,-496 # 13a0 <malloc+0x26c>
     598:	6c2000ef          	jal	c5a <write>
     59c:	05751563          	bne	a0,s7,5e6 <go+0x53c>
      if(fstat(fd1, &st) != 0){
     5a0:	f7840593          	addi	a1,s0,-136
     5a4:	856a                	mv	a0,s10
     5a6:	6ec000ef          	jal	c92 <fstat>
     5aa:	e539                	bnez	a0,5f8 <go+0x54e>
      if(st.size != 1){
     5ac:	f8843583          	ld	a1,-120(s0)
     5b0:	05759d63          	bne	a1,s7,60a <go+0x560>
      if(st.ino > 200){
     5b4:	f7c42583          	lw	a1,-132(s0)
     5b8:	0c800793          	li	a5,200
     5bc:	06b7e163          	bltu	a5,a1,61e <go+0x574>
      close(fd1);
     5c0:	856a                	mv	a0,s10
     5c2:	6a0000ef          	jal	c62 <close>
      unlink("c");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	e2a50513          	addi	a0,a0,-470 # 13f0 <malloc+0x2bc>
     5ce:	6bc000ef          	jal	c8a <unlink>
     5d2:	b66d                	j	17c <go+0xd2>
        printf("grind: create c failed\n");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e2450513          	addi	a0,a0,-476 # 13f8 <malloc+0x2c4>
     5dc:	2a1000ef          	jal	107c <printf>
        exit(1);
     5e0:	4505                	li	a0,1
     5e2:	658000ef          	jal	c3a <exit>
        printf("grind: write c failed\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	e2a50513          	addi	a0,a0,-470 # 1410 <malloc+0x2dc>
     5ee:	28f000ef          	jal	107c <printf>
        exit(1);
     5f2:	4505                	li	a0,1
     5f4:	646000ef          	jal	c3a <exit>
        printf("grind: fstat failed\n");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	e3050513          	addi	a0,a0,-464 # 1428 <malloc+0x2f4>
     600:	27d000ef          	jal	107c <printf>
        exit(1);
     604:	4505                	li	a0,1
     606:	634000ef          	jal	c3a <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60a:	2581                	sext.w	a1,a1
     60c:	00001517          	auipc	a0,0x1
     610:	e3450513          	addi	a0,a0,-460 # 1440 <malloc+0x30c>
     614:	269000ef          	jal	107c <printf>
        exit(1);
     618:	4505                	li	a0,1
     61a:	620000ef          	jal	c3a <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     61e:	00001517          	auipc	a0,0x1
     622:	e4a50513          	addi	a0,a0,-438 # 1468 <malloc+0x334>
     626:	257000ef          	jal	107c <printf>
        exit(1);
     62a:	4505                	li	a0,1
     62c:	60e000ef          	jal	c3a <exit>
      if(pipe(aa) < 0){
     630:	856e                	mv	a0,s11
     632:	618000ef          	jal	c4a <pipe>
     636:	0a054863          	bltz	a0,6e6 <go+0x63c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     63a:	f7040513          	addi	a0,s0,-144
     63e:	60c000ef          	jal	c4a <pipe>
     642:	0a054c63          	bltz	a0,6fa <go+0x650>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     646:	5ec000ef          	jal	c32 <fork>
      if(pid1 == 0){
     64a:	0c050263          	beqz	a0,70e <go+0x664>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     64e:	14054463          	bltz	a0,796 <go+0x6ec>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     652:	5e0000ef          	jal	c32 <fork>
      if(pid2 == 0){
     656:	14050a63          	beqz	a0,7aa <go+0x700>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     65a:	1e054863          	bltz	a0,84a <go+0x7a0>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     65e:	f6842503          	lw	a0,-152(s0)
     662:	600000ef          	jal	c62 <close>
      close(aa[1]);
     666:	f6c42503          	lw	a0,-148(s0)
     66a:	5f8000ef          	jal	c62 <close>
      close(bb[1]);
     66e:	f7442503          	lw	a0,-140(s0)
     672:	5f0000ef          	jal	c62 <close>
      char buf[4] = { 0, 0, 0, 0 };
     676:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     67a:	865e                	mv	a2,s7
     67c:	f6040593          	addi	a1,s0,-160
     680:	f7042503          	lw	a0,-144(s0)
     684:	5ce000ef          	jal	c52 <read>
      read(bb[0], buf+1, 1);
     688:	865e                	mv	a2,s7
     68a:	f6140593          	addi	a1,s0,-159
     68e:	f7042503          	lw	a0,-144(s0)
     692:	5c0000ef          	jal	c52 <read>
      read(bb[0], buf+2, 1);
     696:	865e                	mv	a2,s7
     698:	f6240593          	addi	a1,s0,-158
     69c:	f7042503          	lw	a0,-144(s0)
     6a0:	5b2000ef          	jal	c52 <read>
      close(bb[0]);
     6a4:	f7042503          	lw	a0,-144(s0)
     6a8:	5ba000ef          	jal	c62 <close>
      int st1, st2;
      wait(&st1);
     6ac:	f6440513          	addi	a0,s0,-156
     6b0:	592000ef          	jal	c42 <wait>
      wait(&st2);
     6b4:	f7840513          	addi	a0,s0,-136
     6b8:	58a000ef          	jal	c42 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     6bc:	f6442783          	lw	a5,-156(s0)
     6c0:	f7842703          	lw	a4,-136(s0)
     6c4:	f4e43823          	sd	a4,-176(s0)
     6c8:	00e7ed33          	or	s10,a5,a4
     6cc:	180d1963          	bnez	s10,85e <go+0x7b4>
     6d0:	00001597          	auipc	a1,0x1
     6d4:	e3858593          	addi	a1,a1,-456 # 1508 <malloc+0x3d4>
     6d8:	f6040513          	addi	a0,s0,-160
     6dc:	2d8000ef          	jal	9b4 <strcmp>
     6e0:	a8050ee3          	beqz	a0,17c <go+0xd2>
     6e4:	aab5                	j	860 <go+0x7b6>
        fprintf(2, "grind: pipe failed\n");
     6e6:	00001597          	auipc	a1,0x1
     6ea:	ca258593          	addi	a1,a1,-862 # 1388 <malloc+0x254>
     6ee:	4509                	li	a0,2
     6f0:	163000ef          	jal	1052 <fprintf>
        exit(1);
     6f4:	4505                	li	a0,1
     6f6:	544000ef          	jal	c3a <exit>
        fprintf(2, "grind: pipe failed\n");
     6fa:	00001597          	auipc	a1,0x1
     6fe:	c8e58593          	addi	a1,a1,-882 # 1388 <malloc+0x254>
     702:	4509                	li	a0,2
     704:	14f000ef          	jal	1052 <fprintf>
        exit(1);
     708:	4505                	li	a0,1
     70a:	530000ef          	jal	c3a <exit>
        close(bb[0]);
     70e:	f7042503          	lw	a0,-144(s0)
     712:	550000ef          	jal	c62 <close>
        close(bb[1]);
     716:	f7442503          	lw	a0,-140(s0)
     71a:	548000ef          	jal	c62 <close>
        close(aa[0]);
     71e:	f6842503          	lw	a0,-152(s0)
     722:	540000ef          	jal	c62 <close>
        close(1);
     726:	4505                	li	a0,1
     728:	53a000ef          	jal	c62 <close>
        if(dup(aa[1]) != 1){
     72c:	f6c42503          	lw	a0,-148(s0)
     730:	582000ef          	jal	cb2 <dup>
     734:	4785                	li	a5,1
     736:	00f50c63          	beq	a0,a5,74e <go+0x6a4>
          fprintf(2, "grind: dup failed\n");
     73a:	00001597          	auipc	a1,0x1
     73e:	d5658593          	addi	a1,a1,-682 # 1490 <malloc+0x35c>
     742:	4509                	li	a0,2
     744:	10f000ef          	jal	1052 <fprintf>
          exit(1);
     748:	4505                	li	a0,1
     74a:	4f0000ef          	jal	c3a <exit>
        close(aa[1]);
     74e:	f6c42503          	lw	a0,-148(s0)
     752:	510000ef          	jal	c62 <close>
        char *args[3] = { "echo", "hi", 0 };
     756:	00001797          	auipc	a5,0x1
     75a:	d5278793          	addi	a5,a5,-686 # 14a8 <malloc+0x374>
     75e:	f6f43c23          	sd	a5,-136(s0)
     762:	00001797          	auipc	a5,0x1
     766:	d4e78793          	addi	a5,a5,-690 # 14b0 <malloc+0x37c>
     76a:	f8f43023          	sd	a5,-128(s0)
     76e:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     772:	f7840593          	addi	a1,s0,-136
     776:	00001517          	auipc	a0,0x1
     77a:	d4250513          	addi	a0,a0,-702 # 14b8 <malloc+0x384>
     77e:	4f4000ef          	jal	c72 <exec>
        fprintf(2, "grind: echo: not found\n");
     782:	00001597          	auipc	a1,0x1
     786:	d4658593          	addi	a1,a1,-698 # 14c8 <malloc+0x394>
     78a:	4509                	li	a0,2
     78c:	0c7000ef          	jal	1052 <fprintf>
        exit(2);
     790:	4509                	li	a0,2
     792:	4a8000ef          	jal	c3a <exit>
        fprintf(2, "grind: fork failed\n");
     796:	00001597          	auipc	a1,0x1
     79a:	baa58593          	addi	a1,a1,-1110 # 1340 <malloc+0x20c>
     79e:	4509                	li	a0,2
     7a0:	0b3000ef          	jal	1052 <fprintf>
        exit(3);
     7a4:	450d                	li	a0,3
     7a6:	494000ef          	jal	c3a <exit>
        close(aa[1]);
     7aa:	f6c42503          	lw	a0,-148(s0)
     7ae:	4b4000ef          	jal	c62 <close>
        close(bb[0]);
     7b2:	f7042503          	lw	a0,-144(s0)
     7b6:	4ac000ef          	jal	c62 <close>
        close(0);
     7ba:	4501                	li	a0,0
     7bc:	4a6000ef          	jal	c62 <close>
        if(dup(aa[0]) != 0){
     7c0:	f6842503          	lw	a0,-152(s0)
     7c4:	4ee000ef          	jal	cb2 <dup>
     7c8:	c919                	beqz	a0,7de <go+0x734>
          fprintf(2, "grind: dup failed\n");
     7ca:	00001597          	auipc	a1,0x1
     7ce:	cc658593          	addi	a1,a1,-826 # 1490 <malloc+0x35c>
     7d2:	4509                	li	a0,2
     7d4:	07f000ef          	jal	1052 <fprintf>
          exit(4);
     7d8:	4511                	li	a0,4
     7da:	460000ef          	jal	c3a <exit>
        close(aa[0]);
     7de:	f6842503          	lw	a0,-152(s0)
     7e2:	480000ef          	jal	c62 <close>
        close(1);
     7e6:	4505                	li	a0,1
     7e8:	47a000ef          	jal	c62 <close>
        if(dup(bb[1]) != 1){
     7ec:	f7442503          	lw	a0,-140(s0)
     7f0:	4c2000ef          	jal	cb2 <dup>
     7f4:	4785                	li	a5,1
     7f6:	00f50c63          	beq	a0,a5,80e <go+0x764>
          fprintf(2, "grind: dup failed\n");
     7fa:	00001597          	auipc	a1,0x1
     7fe:	c9658593          	addi	a1,a1,-874 # 1490 <malloc+0x35c>
     802:	4509                	li	a0,2
     804:	04f000ef          	jal	1052 <fprintf>
          exit(5);
     808:	4515                	li	a0,5
     80a:	430000ef          	jal	c3a <exit>
        close(bb[1]);
     80e:	f7442503          	lw	a0,-140(s0)
     812:	450000ef          	jal	c62 <close>
        char *args[2] = { "cat", 0 };
     816:	00001797          	auipc	a5,0x1
     81a:	cca78793          	addi	a5,a5,-822 # 14e0 <malloc+0x3ac>
     81e:	f6f43c23          	sd	a5,-136(s0)
     822:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     826:	f7840593          	addi	a1,s0,-136
     82a:	00001517          	auipc	a0,0x1
     82e:	cbe50513          	addi	a0,a0,-834 # 14e8 <malloc+0x3b4>
     832:	440000ef          	jal	c72 <exec>
        fprintf(2, "grind: cat: not found\n");
     836:	00001597          	auipc	a1,0x1
     83a:	cba58593          	addi	a1,a1,-838 # 14f0 <malloc+0x3bc>
     83e:	4509                	li	a0,2
     840:	013000ef          	jal	1052 <fprintf>
        exit(6);
     844:	4519                	li	a0,6
     846:	3f4000ef          	jal	c3a <exit>
        fprintf(2, "grind: fork failed\n");
     84a:	00001597          	auipc	a1,0x1
     84e:	af658593          	addi	a1,a1,-1290 # 1340 <malloc+0x20c>
     852:	4509                	li	a0,2
     854:	7fe000ef          	jal	1052 <fprintf>
        exit(7);
     858:	451d                	li	a0,7
     85a:	3e0000ef          	jal	c3a <exit>
     85e:	8d3e                	mv	s10,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     860:	f6040693          	addi	a3,s0,-160
     864:	f5043603          	ld	a2,-176(s0)
     868:	85ea                	mv	a1,s10
     86a:	00001517          	auipc	a0,0x1
     86e:	ca650513          	addi	a0,a0,-858 # 1510 <malloc+0x3dc>
     872:	00b000ef          	jal	107c <printf>
        exit(1);
     876:	4505                	li	a0,1
     878:	3c2000ef          	jal	c3a <exit>

000000000000087c <iter>:
  }
}

void
iter()
{
     87c:	7179                	addi	sp,sp,-48
     87e:	f406                	sd	ra,40(sp)
     880:	f022                	sd	s0,32(sp)
     882:	1800                	addi	s0,sp,48
  unlink("a");
     884:	00001517          	auipc	a0,0x1
     888:	ad450513          	addi	a0,a0,-1324 # 1358 <malloc+0x224>
     88c:	3fe000ef          	jal	c8a <unlink>
  unlink("b");
     890:	00001517          	auipc	a0,0x1
     894:	a7850513          	addi	a0,a0,-1416 # 1308 <malloc+0x1d4>
     898:	3f2000ef          	jal	c8a <unlink>
  
  int pid1 = fork();
     89c:	396000ef          	jal	c32 <fork>
  if(pid1 < 0){
     8a0:	02054163          	bltz	a0,8c2 <iter+0x46>
     8a4:	ec26                	sd	s1,24(sp)
     8a6:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     8a8:	e905                	bnez	a0,8d8 <iter+0x5c>
     8aa:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8ac:	00001717          	auipc	a4,0x1
     8b0:	75470713          	addi	a4,a4,1876 # 2000 <rand_next>
     8b4:	631c                	ld	a5,0(a4)
     8b6:	01f7c793          	xori	a5,a5,31
     8ba:	e31c                	sd	a5,0(a4)
    go(0);
     8bc:	4501                	li	a0,0
     8be:	fecff0ef          	jal	aa <go>
     8c2:	ec26                	sd	s1,24(sp)
     8c4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8c6:	00001517          	auipc	a0,0x1
     8ca:	a7a50513          	addi	a0,a0,-1414 # 1340 <malloc+0x20c>
     8ce:	7ae000ef          	jal	107c <printf>
    exit(1);
     8d2:	4505                	li	a0,1
     8d4:	366000ef          	jal	c3a <exit>
     8d8:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8da:	358000ef          	jal	c32 <fork>
     8de:	892a                	mv	s2,a0
  if(pid2 < 0){
     8e0:	02054063          	bltz	a0,900 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     8e4:	e51d                	bnez	a0,912 <iter+0x96>
    rand_next ^= 7177;
     8e6:	00001697          	auipc	a3,0x1
     8ea:	71a68693          	addi	a3,a3,1818 # 2000 <rand_next>
     8ee:	629c                	ld	a5,0(a3)
     8f0:	6709                	lui	a4,0x2
     8f2:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x669>
     8f6:	8fb9                	xor	a5,a5,a4
     8f8:	e29c                	sd	a5,0(a3)
    go(1);
     8fa:	4505                	li	a0,1
     8fc:	faeff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     900:	00001517          	auipc	a0,0x1
     904:	a4050513          	addi	a0,a0,-1472 # 1340 <malloc+0x20c>
     908:	774000ef          	jal	107c <printf>
    exit(1);
     90c:	4505                	li	a0,1
     90e:	32c000ef          	jal	c3a <exit>
    exit(0);
  }

  int st1 = -1;
     912:	57fd                	li	a5,-1
     914:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     918:	fdc40513          	addi	a0,s0,-36
     91c:	326000ef          	jal	c42 <wait>
  if(st1 != 0){
     920:	fdc42783          	lw	a5,-36(s0)
     924:	eb99                	bnez	a5,93a <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     926:	57fd                	li	a5,-1
     928:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     92c:	fd840513          	addi	a0,s0,-40
     930:	312000ef          	jal	c42 <wait>

  exit(0);
     934:	4501                	li	a0,0
     936:	304000ef          	jal	c3a <exit>
    kill(pid1);
     93a:	8526                	mv	a0,s1
     93c:	32e000ef          	jal	c6a <kill>
    kill(pid2);
     940:	854a                	mv	a0,s2
     942:	328000ef          	jal	c6a <kill>
     946:	b7c5                	j	926 <iter+0xaa>

0000000000000948 <main>:
}

int
main()
{
     948:	1101                	addi	sp,sp,-32
     94a:	ec06                	sd	ra,24(sp)
     94c:	e822                	sd	s0,16(sp)
     94e:	e426                	sd	s1,8(sp)
     950:	e04a                	sd	s2,0(sp)
     952:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     954:	4951                	li	s2,20
    rand_next += 1;
     956:	00001497          	auipc	s1,0x1
     95a:	6aa48493          	addi	s1,s1,1706 # 2000 <rand_next>
     95e:	a809                	j	970 <main+0x28>
      iter();
     960:	f1dff0ef          	jal	87c <iter>
    sleep(20);
     964:	854a                	mv	a0,s2
     966:	364000ef          	jal	cca <sleep>
    rand_next += 1;
     96a:	609c                	ld	a5,0(s1)
     96c:	0785                	addi	a5,a5,1
     96e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     970:	2c2000ef          	jal	c32 <fork>
    if(pid == 0){
     974:	d575                	beqz	a0,960 <main+0x18>
    if(pid > 0){
     976:	fea057e3          	blez	a0,964 <main+0x1c>
      wait(0);
     97a:	4501                	li	a0,0
     97c:	2c6000ef          	jal	c42 <wait>
     980:	b7d5                	j	964 <main+0x1c>

0000000000000982 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     982:	1141                	addi	sp,sp,-16
     984:	e406                	sd	ra,8(sp)
     986:	e022                	sd	s0,0(sp)
     988:	0800                	addi	s0,sp,16
  extern int main();
  main();
     98a:	fbfff0ef          	jal	948 <main>
  exit(0);
     98e:	4501                	li	a0,0
     990:	2aa000ef          	jal	c3a <exit>

0000000000000994 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     994:	1141                	addi	sp,sp,-16
     996:	e406                	sd	ra,8(sp)
     998:	e022                	sd	s0,0(sp)
     99a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     99c:	87aa                	mv	a5,a0
     99e:	0585                	addi	a1,a1,1
     9a0:	0785                	addi	a5,a5,1
     9a2:	fff5c703          	lbu	a4,-1(a1)
     9a6:	fee78fa3          	sb	a4,-1(a5)
     9aa:	fb75                	bnez	a4,99e <strcpy+0xa>
    ;
  return os;
}
     9ac:	60a2                	ld	ra,8(sp)
     9ae:	6402                	ld	s0,0(sp)
     9b0:	0141                	addi	sp,sp,16
     9b2:	8082                	ret

00000000000009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9b4:	1141                	addi	sp,sp,-16
     9b6:	e406                	sd	ra,8(sp)
     9b8:	e022                	sd	s0,0(sp)
     9ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9bc:	00054783          	lbu	a5,0(a0)
     9c0:	cb91                	beqz	a5,9d4 <strcmp+0x20>
     9c2:	0005c703          	lbu	a4,0(a1)
     9c6:	00f71763          	bne	a4,a5,9d4 <strcmp+0x20>
    p++, q++;
     9ca:	0505                	addi	a0,a0,1
     9cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9ce:	00054783          	lbu	a5,0(a0)
     9d2:	fbe5                	bnez	a5,9c2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9d4:	0005c503          	lbu	a0,0(a1)
}
     9d8:	40a7853b          	subw	a0,a5,a0
     9dc:	60a2                	ld	ra,8(sp)
     9de:	6402                	ld	s0,0(sp)
     9e0:	0141                	addi	sp,sp,16
     9e2:	8082                	ret

00000000000009e4 <strlen>:

uint
strlen(const char *s)
{
     9e4:	1141                	addi	sp,sp,-16
     9e6:	e406                	sd	ra,8(sp)
     9e8:	e022                	sd	s0,0(sp)
     9ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9ec:	00054783          	lbu	a5,0(a0)
     9f0:	cf99                	beqz	a5,a0e <strlen+0x2a>
     9f2:	0505                	addi	a0,a0,1
     9f4:	87aa                	mv	a5,a0
     9f6:	86be                	mv	a3,a5
     9f8:	0785                	addi	a5,a5,1
     9fa:	fff7c703          	lbu	a4,-1(a5)
     9fe:	ff65                	bnez	a4,9f6 <strlen+0x12>
     a00:	40a6853b          	subw	a0,a3,a0
     a04:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a06:	60a2                	ld	ra,8(sp)
     a08:	6402                	ld	s0,0(sp)
     a0a:	0141                	addi	sp,sp,16
     a0c:	8082                	ret
  for(n = 0; s[n]; n++)
     a0e:	4501                	li	a0,0
     a10:	bfdd                	j	a06 <strlen+0x22>

0000000000000a12 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a12:	1141                	addi	sp,sp,-16
     a14:	e406                	sd	ra,8(sp)
     a16:	e022                	sd	s0,0(sp)
     a18:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a1a:	ca19                	beqz	a2,a30 <memset+0x1e>
     a1c:	87aa                	mv	a5,a0
     a1e:	1602                	slli	a2,a2,0x20
     a20:	9201                	srli	a2,a2,0x20
     a22:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a26:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a2a:	0785                	addi	a5,a5,1
     a2c:	fee79de3          	bne	a5,a4,a26 <memset+0x14>
  }
  return dst;
}
     a30:	60a2                	ld	ra,8(sp)
     a32:	6402                	ld	s0,0(sp)
     a34:	0141                	addi	sp,sp,16
     a36:	8082                	ret

0000000000000a38 <strchr>:

char*
strchr(const char *s, char c)
{
     a38:	1141                	addi	sp,sp,-16
     a3a:	e406                	sd	ra,8(sp)
     a3c:	e022                	sd	s0,0(sp)
     a3e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a40:	00054783          	lbu	a5,0(a0)
     a44:	cf81                	beqz	a5,a5c <strchr+0x24>
    if(*s == c)
     a46:	00f58763          	beq	a1,a5,a54 <strchr+0x1c>
  for(; *s; s++)
     a4a:	0505                	addi	a0,a0,1
     a4c:	00054783          	lbu	a5,0(a0)
     a50:	fbfd                	bnez	a5,a46 <strchr+0xe>
      return (char*)s;
  return 0;
     a52:	4501                	li	a0,0
}
     a54:	60a2                	ld	ra,8(sp)
     a56:	6402                	ld	s0,0(sp)
     a58:	0141                	addi	sp,sp,16
     a5a:	8082                	ret
  return 0;
     a5c:	4501                	li	a0,0
     a5e:	bfdd                	j	a54 <strchr+0x1c>

0000000000000a60 <gets>:

char*
gets(char *buf, int max)
{
     a60:	7159                	addi	sp,sp,-112
     a62:	f486                	sd	ra,104(sp)
     a64:	f0a2                	sd	s0,96(sp)
     a66:	eca6                	sd	s1,88(sp)
     a68:	e8ca                	sd	s2,80(sp)
     a6a:	e4ce                	sd	s3,72(sp)
     a6c:	e0d2                	sd	s4,64(sp)
     a6e:	fc56                	sd	s5,56(sp)
     a70:	f85a                	sd	s6,48(sp)
     a72:	f45e                	sd	s7,40(sp)
     a74:	f062                	sd	s8,32(sp)
     a76:	ec66                	sd	s9,24(sp)
     a78:	e86a                	sd	s10,16(sp)
     a7a:	1880                	addi	s0,sp,112
     a7c:	8caa                	mv	s9,a0
     a7e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a80:	892a                	mv	s2,a0
     a82:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a84:	f9f40b13          	addi	s6,s0,-97
     a88:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a8a:	4ba9                	li	s7,10
     a8c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     a8e:	8d26                	mv	s10,s1
     a90:	0014899b          	addiw	s3,s1,1
     a94:	84ce                	mv	s1,s3
     a96:	0349d563          	bge	s3,s4,ac0 <gets+0x60>
    cc = read(0, &c, 1);
     a9a:	8656                	mv	a2,s5
     a9c:	85da                	mv	a1,s6
     a9e:	4501                	li	a0,0
     aa0:	1b2000ef          	jal	c52 <read>
    if(cc < 1)
     aa4:	00a05e63          	blez	a0,ac0 <gets+0x60>
    buf[i++] = c;
     aa8:	f9f44783          	lbu	a5,-97(s0)
     aac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ab0:	01778763          	beq	a5,s7,abe <gets+0x5e>
     ab4:	0905                	addi	s2,s2,1
     ab6:	fd879ce3          	bne	a5,s8,a8e <gets+0x2e>
    buf[i++] = c;
     aba:	8d4e                	mv	s10,s3
     abc:	a011                	j	ac0 <gets+0x60>
     abe:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     ac0:	9d66                	add	s10,s10,s9
     ac2:	000d0023          	sb	zero,0(s10)
  return buf;
}
     ac6:	8566                	mv	a0,s9
     ac8:	70a6                	ld	ra,104(sp)
     aca:	7406                	ld	s0,96(sp)
     acc:	64e6                	ld	s1,88(sp)
     ace:	6946                	ld	s2,80(sp)
     ad0:	69a6                	ld	s3,72(sp)
     ad2:	6a06                	ld	s4,64(sp)
     ad4:	7ae2                	ld	s5,56(sp)
     ad6:	7b42                	ld	s6,48(sp)
     ad8:	7ba2                	ld	s7,40(sp)
     ada:	7c02                	ld	s8,32(sp)
     adc:	6ce2                	ld	s9,24(sp)
     ade:	6d42                	ld	s10,16(sp)
     ae0:	6165                	addi	sp,sp,112
     ae2:	8082                	ret

0000000000000ae4 <stat>:

int
stat(const char *n, struct stat *st)
{
     ae4:	1101                	addi	sp,sp,-32
     ae6:	ec06                	sd	ra,24(sp)
     ae8:	e822                	sd	s0,16(sp)
     aea:	e04a                	sd	s2,0(sp)
     aec:	1000                	addi	s0,sp,32
     aee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     af0:	4581                	li	a1,0
     af2:	188000ef          	jal	c7a <open>
  if(fd < 0)
     af6:	02054263          	bltz	a0,b1a <stat+0x36>
     afa:	e426                	sd	s1,8(sp)
     afc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     afe:	85ca                	mv	a1,s2
     b00:	192000ef          	jal	c92 <fstat>
     b04:	892a                	mv	s2,a0
  close(fd);
     b06:	8526                	mv	a0,s1
     b08:	15a000ef          	jal	c62 <close>
  return r;
     b0c:	64a2                	ld	s1,8(sp)
}
     b0e:	854a                	mv	a0,s2
     b10:	60e2                	ld	ra,24(sp)
     b12:	6442                	ld	s0,16(sp)
     b14:	6902                	ld	s2,0(sp)
     b16:	6105                	addi	sp,sp,32
     b18:	8082                	ret
    return -1;
     b1a:	597d                	li	s2,-1
     b1c:	bfcd                	j	b0e <stat+0x2a>

0000000000000b1e <atoi>:

int
atoi(const char *s)
{
     b1e:	1141                	addi	sp,sp,-16
     b20:	e406                	sd	ra,8(sp)
     b22:	e022                	sd	s0,0(sp)
     b24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b26:	00054683          	lbu	a3,0(a0)
     b2a:	fd06879b          	addiw	a5,a3,-48
     b2e:	0ff7f793          	zext.b	a5,a5
     b32:	4625                	li	a2,9
     b34:	02f66963          	bltu	a2,a5,b66 <atoi+0x48>
     b38:	872a                	mv	a4,a0
  n = 0;
     b3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b3c:	0705                	addi	a4,a4,1
     b3e:	0025179b          	slliw	a5,a0,0x2
     b42:	9fa9                	addw	a5,a5,a0
     b44:	0017979b          	slliw	a5,a5,0x1
     b48:	9fb5                	addw	a5,a5,a3
     b4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b4e:	00074683          	lbu	a3,0(a4)
     b52:	fd06879b          	addiw	a5,a3,-48
     b56:	0ff7f793          	zext.b	a5,a5
     b5a:	fef671e3          	bgeu	a2,a5,b3c <atoi+0x1e>
  return n;
}
     b5e:	60a2                	ld	ra,8(sp)
     b60:	6402                	ld	s0,0(sp)
     b62:	0141                	addi	sp,sp,16
     b64:	8082                	ret
  n = 0;
     b66:	4501                	li	a0,0
     b68:	bfdd                	j	b5e <atoi+0x40>

0000000000000b6a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b6a:	1141                	addi	sp,sp,-16
     b6c:	e406                	sd	ra,8(sp)
     b6e:	e022                	sd	s0,0(sp)
     b70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b72:	02b57563          	bgeu	a0,a1,b9c <memmove+0x32>
    while(n-- > 0)
     b76:	00c05f63          	blez	a2,b94 <memmove+0x2a>
     b7a:	1602                	slli	a2,a2,0x20
     b7c:	9201                	srli	a2,a2,0x20
     b7e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b82:	872a                	mv	a4,a0
      *dst++ = *src++;
     b84:	0585                	addi	a1,a1,1
     b86:	0705                	addi	a4,a4,1
     b88:	fff5c683          	lbu	a3,-1(a1)
     b8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b90:	fee79ae3          	bne	a5,a4,b84 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b94:	60a2                	ld	ra,8(sp)
     b96:	6402                	ld	s0,0(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret
    dst += n;
     b9c:	00c50733          	add	a4,a0,a2
    src += n;
     ba0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ba2:	fec059e3          	blez	a2,b94 <memmove+0x2a>
     ba6:	fff6079b          	addiw	a5,a2,-1
     baa:	1782                	slli	a5,a5,0x20
     bac:	9381                	srli	a5,a5,0x20
     bae:	fff7c793          	not	a5,a5
     bb2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bb4:	15fd                	addi	a1,a1,-1
     bb6:	177d                	addi	a4,a4,-1
     bb8:	0005c683          	lbu	a3,0(a1)
     bbc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bc0:	fef71ae3          	bne	a4,a5,bb4 <memmove+0x4a>
     bc4:	bfc1                	j	b94 <memmove+0x2a>

0000000000000bc6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e406                	sd	ra,8(sp)
     bca:	e022                	sd	s0,0(sp)
     bcc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bce:	ca0d                	beqz	a2,c00 <memcmp+0x3a>
     bd0:	fff6069b          	addiw	a3,a2,-1
     bd4:	1682                	slli	a3,a3,0x20
     bd6:	9281                	srli	a3,a3,0x20
     bd8:	0685                	addi	a3,a3,1
     bda:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bdc:	00054783          	lbu	a5,0(a0)
     be0:	0005c703          	lbu	a4,0(a1)
     be4:	00e79863          	bne	a5,a4,bf4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     be8:	0505                	addi	a0,a0,1
    p2++;
     bea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bec:	fed518e3          	bne	a0,a3,bdc <memcmp+0x16>
  }
  return 0;
     bf0:	4501                	li	a0,0
     bf2:	a019                	j	bf8 <memcmp+0x32>
      return *p1 - *p2;
     bf4:	40e7853b          	subw	a0,a5,a4
}
     bf8:	60a2                	ld	ra,8(sp)
     bfa:	6402                	ld	s0,0(sp)
     bfc:	0141                	addi	sp,sp,16
     bfe:	8082                	ret
  return 0;
     c00:	4501                	li	a0,0
     c02:	bfdd                	j	bf8 <memcmp+0x32>

0000000000000c04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c04:	1141                	addi	sp,sp,-16
     c06:	e406                	sd	ra,8(sp)
     c08:	e022                	sd	s0,0(sp)
     c0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c0c:	f5fff0ef          	jal	b6a <memmove>
}
     c10:	60a2                	ld	ra,8(sp)
     c12:	6402                	ld	s0,0(sp)
     c14:	0141                	addi	sp,sp,16
     c16:	8082                	ret

0000000000000c18 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     c18:	1141                	addi	sp,sp,-16
     c1a:	e406                	sd	ra,8(sp)
     c1c:	e022                	sd	s0,0(sp)
     c1e:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     c20:	040007b7          	lui	a5,0x4000
     c24:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdbf5>
     c26:	07b2                	slli	a5,a5,0xc
}
     c28:	4388                	lw	a0,0(a5)
     c2a:	60a2                	ld	ra,8(sp)
     c2c:	6402                	ld	s0,0(sp)
     c2e:	0141                	addi	sp,sp,16
     c30:	8082                	ret

0000000000000c32 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c32:	4885                	li	a7,1
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <exit>:
.global exit
exit:
 li a7, SYS_exit
     c3a:	4889                	li	a7,2
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c42:	488d                	li	a7,3
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c4a:	4891                	li	a7,4
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <read>:
.global read
read:
 li a7, SYS_read
     c52:	4895                	li	a7,5
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <write>:
.global write
write:
 li a7, SYS_write
     c5a:	48c1                	li	a7,16
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <close>:
.global close
close:
 li a7, SYS_close
     c62:	48d5                	li	a7,21
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <kill>:
.global kill
kill:
 li a7, SYS_kill
     c6a:	4899                	li	a7,6
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c72:	489d                	li	a7,7
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <open>:
.global open
open:
 li a7, SYS_open
     c7a:	48bd                	li	a7,15
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c82:	48c5                	li	a7,17
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c8a:	48c9                	li	a7,18
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c92:	48a1                	li	a7,8
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <link>:
.global link
link:
 li a7, SYS_link
     c9a:	48cd                	li	a7,19
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ca2:	48d1                	li	a7,20
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     caa:	48a5                	li	a7,9
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cb2:	48a9                	li	a7,10
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cba:	48ad                	li	a7,11
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     cc2:	48b1                	li	a7,12
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     cca:	48b5                	li	a7,13
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cd2:	48b9                	li	a7,14
 ecall
     cd4:	00000073          	ecall
 ret
     cd8:	8082                	ret

0000000000000cda <bind>:
.global bind
bind:
 li a7, SYS_bind
     cda:	48f5                	li	a7,29
 ecall
     cdc:	00000073          	ecall
 ret
     ce0:	8082                	ret

0000000000000ce2 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
     ce2:	48f9                	li	a7,30
 ecall
     ce4:	00000073          	ecall
 ret
     ce8:	8082                	ret

0000000000000cea <send>:
.global send
send:
 li a7, SYS_send
     cea:	48fd                	li	a7,31
 ecall
     cec:	00000073          	ecall
 ret
     cf0:	8082                	ret

0000000000000cf2 <recv>:
.global recv
recv:
 li a7, SYS_recv
     cf2:	02000893          	li	a7,32
 ecall
     cf6:	00000073          	ecall
 ret
     cfa:	8082                	ret

0000000000000cfc <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
     cfc:	02100893          	li	a7,33
 ecall
     d00:	00000073          	ecall
 ret
     d04:	8082                	ret

0000000000000d06 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
     d06:	02200893          	li	a7,34
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     d10:	02400893          	li	a7,36
 ecall
     d14:	00000073          	ecall
 ret
     d18:	8082                	ret

0000000000000d1a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d1a:	1101                	addi	sp,sp,-32
     d1c:	ec06                	sd	ra,24(sp)
     d1e:	e822                	sd	s0,16(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d26:	4605                	li	a2,1
     d28:	fef40593          	addi	a1,s0,-17
     d2c:	f2fff0ef          	jal	c5a <write>
}
     d30:	60e2                	ld	ra,24(sp)
     d32:	6442                	ld	s0,16(sp)
     d34:	6105                	addi	sp,sp,32
     d36:	8082                	ret

0000000000000d38 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d38:	7139                	addi	sp,sp,-64
     d3a:	fc06                	sd	ra,56(sp)
     d3c:	f822                	sd	s0,48(sp)
     d3e:	f426                	sd	s1,40(sp)
     d40:	f04a                	sd	s2,32(sp)
     d42:	ec4e                	sd	s3,24(sp)
     d44:	0080                	addi	s0,sp,64
     d46:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d48:	c299                	beqz	a3,d4e <printint+0x16>
     d4a:	0605ce63          	bltz	a1,dc6 <printint+0x8e>
  neg = 0;
     d4e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d50:	fc040313          	addi	t1,s0,-64
  neg = 0;
     d54:	869a                	mv	a3,t1
  i = 0;
     d56:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     d58:	00001817          	auipc	a6,0x1
     d5c:	84880813          	addi	a6,a6,-1976 # 15a0 <digits>
     d60:	88be                	mv	a7,a5
     d62:	0017851b          	addiw	a0,a5,1
     d66:	87aa                	mv	a5,a0
     d68:	02c5f73b          	remuw	a4,a1,a2
     d6c:	1702                	slli	a4,a4,0x20
     d6e:	9301                	srli	a4,a4,0x20
     d70:	9742                	add	a4,a4,a6
     d72:	00074703          	lbu	a4,0(a4)
     d76:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     d7a:	872e                	mv	a4,a1
     d7c:	02c5d5bb          	divuw	a1,a1,a2
     d80:	0685                	addi	a3,a3,1
     d82:	fcc77fe3          	bgeu	a4,a2,d60 <printint+0x28>
  if(neg)
     d86:	000e0c63          	beqz	t3,d9e <printint+0x66>
    buf[i++] = '-';
     d8a:	fd050793          	addi	a5,a0,-48
     d8e:	00878533          	add	a0,a5,s0
     d92:	02d00793          	li	a5,45
     d96:	fef50823          	sb	a5,-16(a0)
     d9a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     d9e:	fff7899b          	addiw	s3,a5,-1
     da2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     da6:	fff4c583          	lbu	a1,-1(s1)
     daa:	854a                	mv	a0,s2
     dac:	f6fff0ef          	jal	d1a <putc>
  while(--i >= 0)
     db0:	39fd                	addiw	s3,s3,-1
     db2:	14fd                	addi	s1,s1,-1
     db4:	fe09d9e3          	bgez	s3,da6 <printint+0x6e>
}
     db8:	70e2                	ld	ra,56(sp)
     dba:	7442                	ld	s0,48(sp)
     dbc:	74a2                	ld	s1,40(sp)
     dbe:	7902                	ld	s2,32(sp)
     dc0:	69e2                	ld	s3,24(sp)
     dc2:	6121                	addi	sp,sp,64
     dc4:	8082                	ret
    x = -xx;
     dc6:	40b005bb          	negw	a1,a1
    neg = 1;
     dca:	4e05                	li	t3,1
    x = -xx;
     dcc:	b751                	j	d50 <printint+0x18>

0000000000000dce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dce:	711d                	addi	sp,sp,-96
     dd0:	ec86                	sd	ra,88(sp)
     dd2:	e8a2                	sd	s0,80(sp)
     dd4:	e4a6                	sd	s1,72(sp)
     dd6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dd8:	0005c483          	lbu	s1,0(a1)
     ddc:	26048663          	beqz	s1,1048 <vprintf+0x27a>
     de0:	e0ca                	sd	s2,64(sp)
     de2:	fc4e                	sd	s3,56(sp)
     de4:	f852                	sd	s4,48(sp)
     de6:	f456                	sd	s5,40(sp)
     de8:	f05a                	sd	s6,32(sp)
     dea:	ec5e                	sd	s7,24(sp)
     dec:	e862                	sd	s8,16(sp)
     dee:	e466                	sd	s9,8(sp)
     df0:	8b2a                	mv	s6,a0
     df2:	8a2e                	mv	s4,a1
     df4:	8bb2                	mv	s7,a2
  state = 0;
     df6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     df8:	4901                	li	s2,0
     dfa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dfc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e00:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e04:	06c00c93          	li	s9,108
     e08:	a00d                	j	e2a <vprintf+0x5c>
        putc(fd, c0);
     e0a:	85a6                	mv	a1,s1
     e0c:	855a                	mv	a0,s6
     e0e:	f0dff0ef          	jal	d1a <putc>
     e12:	a019                	j	e18 <vprintf+0x4a>
    } else if(state == '%'){
     e14:	03598363          	beq	s3,s5,e3a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     e18:	0019079b          	addiw	a5,s2,1
     e1c:	893e                	mv	s2,a5
     e1e:	873e                	mv	a4,a5
     e20:	97d2                	add	a5,a5,s4
     e22:	0007c483          	lbu	s1,0(a5)
     e26:	20048963          	beqz	s1,1038 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
     e2a:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e2e:	fe0993e3          	bnez	s3,e14 <vprintf+0x46>
      if(c0 == '%'){
     e32:	fd579ce3          	bne	a5,s5,e0a <vprintf+0x3c>
        state = '%';
     e36:	89be                	mv	s3,a5
     e38:	b7c5                	j	e18 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e3a:	00ea06b3          	add	a3,s4,a4
     e3e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e42:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e44:	c681                	beqz	a3,e4c <vprintf+0x7e>
     e46:	9752                	add	a4,a4,s4
     e48:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e4c:	03878e63          	beq	a5,s8,e88 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     e50:	05978863          	beq	a5,s9,ea0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e54:	07500713          	li	a4,117
     e58:	0ee78263          	beq	a5,a4,f3c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e5c:	07800713          	li	a4,120
     e60:	12e78463          	beq	a5,a4,f88 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e64:	07000713          	li	a4,112
     e68:	14e78963          	beq	a5,a4,fba <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e6c:	07300713          	li	a4,115
     e70:	18e78863          	beq	a5,a4,1000 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e74:	02500713          	li	a4,37
     e78:	04e79463          	bne	a5,a4,ec0 <vprintf+0xf2>
        putc(fd, '%');
     e7c:	85ba                	mv	a1,a4
     e7e:	855a                	mv	a0,s6
     e80:	e9bff0ef          	jal	d1a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e84:	4981                	li	s3,0
     e86:	bf49                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e88:	008b8493          	addi	s1,s7,8
     e8c:	4685                	li	a3,1
     e8e:	4629                	li	a2,10
     e90:	000ba583          	lw	a1,0(s7)
     e94:	855a                	mv	a0,s6
     e96:	ea3ff0ef          	jal	d38 <printint>
     e9a:	8ba6                	mv	s7,s1
      state = 0;
     e9c:	4981                	li	s3,0
     e9e:	bfad                	j	e18 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     ea0:	06400793          	li	a5,100
     ea4:	02f68963          	beq	a3,a5,ed6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ea8:	06c00793          	li	a5,108
     eac:	04f68263          	beq	a3,a5,ef0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     eb0:	07500793          	li	a5,117
     eb4:	0af68063          	beq	a3,a5,f54 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     eb8:	07800793          	li	a5,120
     ebc:	0ef68263          	beq	a3,a5,fa0 <vprintf+0x1d2>
        putc(fd, '%');
     ec0:	02500593          	li	a1,37
     ec4:	855a                	mv	a0,s6
     ec6:	e55ff0ef          	jal	d1a <putc>
        putc(fd, c0);
     eca:	85a6                	mv	a1,s1
     ecc:	855a                	mv	a0,s6
     ece:	e4dff0ef          	jal	d1a <putc>
      state = 0;
     ed2:	4981                	li	s3,0
     ed4:	b791                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ed6:	008b8493          	addi	s1,s7,8
     eda:	4685                	li	a3,1
     edc:	4629                	li	a2,10
     ede:	000ba583          	lw	a1,0(s7)
     ee2:	855a                	mv	a0,s6
     ee4:	e55ff0ef          	jal	d38 <printint>
        i += 1;
     ee8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     eea:	8ba6                	mv	s7,s1
      state = 0;
     eec:	4981                	li	s3,0
        i += 1;
     eee:	b72d                	j	e18 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ef0:	06400793          	li	a5,100
     ef4:	02f60763          	beq	a2,a5,f22 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ef8:	07500793          	li	a5,117
     efc:	06f60963          	beq	a2,a5,f6e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f00:	07800793          	li	a5,120
     f04:	faf61ee3          	bne	a2,a5,ec0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f08:	008b8493          	addi	s1,s7,8
     f0c:	4681                	li	a3,0
     f0e:	4641                	li	a2,16
     f10:	000ba583          	lw	a1,0(s7)
     f14:	855a                	mv	a0,s6
     f16:	e23ff0ef          	jal	d38 <printint>
        i += 2;
     f1a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f1c:	8ba6                	mv	s7,s1
      state = 0;
     f1e:	4981                	li	s3,0
        i += 2;
     f20:	bde5                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f22:	008b8493          	addi	s1,s7,8
     f26:	4685                	li	a3,1
     f28:	4629                	li	a2,10
     f2a:	000ba583          	lw	a1,0(s7)
     f2e:	855a                	mv	a0,s6
     f30:	e09ff0ef          	jal	d38 <printint>
        i += 2;
     f34:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f36:	8ba6                	mv	s7,s1
      state = 0;
     f38:	4981                	li	s3,0
        i += 2;
     f3a:	bdf9                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     f3c:	008b8493          	addi	s1,s7,8
     f40:	4681                	li	a3,0
     f42:	4629                	li	a2,10
     f44:	000ba583          	lw	a1,0(s7)
     f48:	855a                	mv	a0,s6
     f4a:	defff0ef          	jal	d38 <printint>
     f4e:	8ba6                	mv	s7,s1
      state = 0;
     f50:	4981                	li	s3,0
     f52:	b5d9                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f54:	008b8493          	addi	s1,s7,8
     f58:	4681                	li	a3,0
     f5a:	4629                	li	a2,10
     f5c:	000ba583          	lw	a1,0(s7)
     f60:	855a                	mv	a0,s6
     f62:	dd7ff0ef          	jal	d38 <printint>
        i += 1;
     f66:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f68:	8ba6                	mv	s7,s1
      state = 0;
     f6a:	4981                	li	s3,0
        i += 1;
     f6c:	b575                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f6e:	008b8493          	addi	s1,s7,8
     f72:	4681                	li	a3,0
     f74:	4629                	li	a2,10
     f76:	000ba583          	lw	a1,0(s7)
     f7a:	855a                	mv	a0,s6
     f7c:	dbdff0ef          	jal	d38 <printint>
        i += 2;
     f80:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f82:	8ba6                	mv	s7,s1
      state = 0;
     f84:	4981                	li	s3,0
        i += 2;
     f86:	bd49                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     f88:	008b8493          	addi	s1,s7,8
     f8c:	4681                	li	a3,0
     f8e:	4641                	li	a2,16
     f90:	000ba583          	lw	a1,0(s7)
     f94:	855a                	mv	a0,s6
     f96:	da3ff0ef          	jal	d38 <printint>
     f9a:	8ba6                	mv	s7,s1
      state = 0;
     f9c:	4981                	li	s3,0
     f9e:	bdad                	j	e18 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fa0:	008b8493          	addi	s1,s7,8
     fa4:	4681                	li	a3,0
     fa6:	4641                	li	a2,16
     fa8:	000ba583          	lw	a1,0(s7)
     fac:	855a                	mv	a0,s6
     fae:	d8bff0ef          	jal	d38 <printint>
        i += 1;
     fb2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb4:	8ba6                	mv	s7,s1
      state = 0;
     fb6:	4981                	li	s3,0
        i += 1;
     fb8:	b585                	j	e18 <vprintf+0x4a>
     fba:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fbc:	008b8d13          	addi	s10,s7,8
     fc0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fc4:	03000593          	li	a1,48
     fc8:	855a                	mv	a0,s6
     fca:	d51ff0ef          	jal	d1a <putc>
  putc(fd, 'x');
     fce:	07800593          	li	a1,120
     fd2:	855a                	mv	a0,s6
     fd4:	d47ff0ef          	jal	d1a <putc>
     fd8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fda:	00000b97          	auipc	s7,0x0
     fde:	5c6b8b93          	addi	s7,s7,1478 # 15a0 <digits>
     fe2:	03c9d793          	srli	a5,s3,0x3c
     fe6:	97de                	add	a5,a5,s7
     fe8:	0007c583          	lbu	a1,0(a5)
     fec:	855a                	mv	a0,s6
     fee:	d2dff0ef          	jal	d1a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ff2:	0992                	slli	s3,s3,0x4
     ff4:	34fd                	addiw	s1,s1,-1
     ff6:	f4f5                	bnez	s1,fe2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     ff8:	8bea                	mv	s7,s10
      state = 0;
     ffa:	4981                	li	s3,0
     ffc:	6d02                	ld	s10,0(sp)
     ffe:	bd29                	j	e18 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1000:	008b8993          	addi	s3,s7,8
    1004:	000bb483          	ld	s1,0(s7)
    1008:	cc91                	beqz	s1,1024 <vprintf+0x256>
        for(; *s; s++)
    100a:	0004c583          	lbu	a1,0(s1)
    100e:	c195                	beqz	a1,1032 <vprintf+0x264>
          putc(fd, *s);
    1010:	855a                	mv	a0,s6
    1012:	d09ff0ef          	jal	d1a <putc>
        for(; *s; s++)
    1016:	0485                	addi	s1,s1,1
    1018:	0004c583          	lbu	a1,0(s1)
    101c:	f9f5                	bnez	a1,1010 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    101e:	8bce                	mv	s7,s3
      state = 0;
    1020:	4981                	li	s3,0
    1022:	bbdd                	j	e18 <vprintf+0x4a>
          s = "(null)";
    1024:	00000497          	auipc	s1,0x0
    1028:	51448493          	addi	s1,s1,1300 # 1538 <malloc+0x404>
        for(; *s; s++)
    102c:	02800593          	li	a1,40
    1030:	b7c5                	j	1010 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    1032:	8bce                	mv	s7,s3
      state = 0;
    1034:	4981                	li	s3,0
    1036:	b3cd                	j	e18 <vprintf+0x4a>
    1038:	6906                	ld	s2,64(sp)
    103a:	79e2                	ld	s3,56(sp)
    103c:	7a42                	ld	s4,48(sp)
    103e:	7aa2                	ld	s5,40(sp)
    1040:	7b02                	ld	s6,32(sp)
    1042:	6be2                	ld	s7,24(sp)
    1044:	6c42                	ld	s8,16(sp)
    1046:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1048:	60e6                	ld	ra,88(sp)
    104a:	6446                	ld	s0,80(sp)
    104c:	64a6                	ld	s1,72(sp)
    104e:	6125                	addi	sp,sp,96
    1050:	8082                	ret

0000000000001052 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1052:	715d                	addi	sp,sp,-80
    1054:	ec06                	sd	ra,24(sp)
    1056:	e822                	sd	s0,16(sp)
    1058:	1000                	addi	s0,sp,32
    105a:	e010                	sd	a2,0(s0)
    105c:	e414                	sd	a3,8(s0)
    105e:	e818                	sd	a4,16(s0)
    1060:	ec1c                	sd	a5,24(s0)
    1062:	03043023          	sd	a6,32(s0)
    1066:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    106a:	8622                	mv	a2,s0
    106c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1070:	d5fff0ef          	jal	dce <vprintf>
}
    1074:	60e2                	ld	ra,24(sp)
    1076:	6442                	ld	s0,16(sp)
    1078:	6161                	addi	sp,sp,80
    107a:	8082                	ret

000000000000107c <printf>:

void
printf(const char *fmt, ...)
{
    107c:	711d                	addi	sp,sp,-96
    107e:	ec06                	sd	ra,24(sp)
    1080:	e822                	sd	s0,16(sp)
    1082:	1000                	addi	s0,sp,32
    1084:	e40c                	sd	a1,8(s0)
    1086:	e810                	sd	a2,16(s0)
    1088:	ec14                	sd	a3,24(s0)
    108a:	f018                	sd	a4,32(s0)
    108c:	f41c                	sd	a5,40(s0)
    108e:	03043823          	sd	a6,48(s0)
    1092:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1096:	00840613          	addi	a2,s0,8
    109a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    109e:	85aa                	mv	a1,a0
    10a0:	4505                	li	a0,1
    10a2:	d2dff0ef          	jal	dce <vprintf>
}
    10a6:	60e2                	ld	ra,24(sp)
    10a8:	6442                	ld	s0,16(sp)
    10aa:	6125                	addi	sp,sp,96
    10ac:	8082                	ret

00000000000010ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10ae:	1141                	addi	sp,sp,-16
    10b0:	e406                	sd	ra,8(sp)
    10b2:	e022                	sd	s0,0(sp)
    10b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ba:	00001797          	auipc	a5,0x1
    10be:	f567b783          	ld	a5,-170(a5) # 2010 <freep>
    10c2:	a02d                	j	10ec <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10c4:	4618                	lw	a4,8(a2)
    10c6:	9f2d                	addw	a4,a4,a1
    10c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10cc:	6398                	ld	a4,0(a5)
    10ce:	6310                	ld	a2,0(a4)
    10d0:	a83d                	j	110e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10d2:	ff852703          	lw	a4,-8(a0)
    10d6:	9f31                	addw	a4,a4,a2
    10d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10da:	ff053683          	ld	a3,-16(a0)
    10de:	a091                	j	1122 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10e0:	6398                	ld	a4,0(a5)
    10e2:	00e7e463          	bltu	a5,a4,10ea <free+0x3c>
    10e6:	00e6ea63          	bltu	a3,a4,10fa <free+0x4c>
{
    10ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ec:	fed7fae3          	bgeu	a5,a3,10e0 <free+0x32>
    10f0:	6398                	ld	a4,0(a5)
    10f2:	00e6e463          	bltu	a3,a4,10fa <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10f6:	fee7eae3          	bltu	a5,a4,10ea <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    10fa:	ff852583          	lw	a1,-8(a0)
    10fe:	6390                	ld	a2,0(a5)
    1100:	02059813          	slli	a6,a1,0x20
    1104:	01c85713          	srli	a4,a6,0x1c
    1108:	9736                	add	a4,a4,a3
    110a:	fae60de3          	beq	a2,a4,10c4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    110e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1112:	4790                	lw	a2,8(a5)
    1114:	02061593          	slli	a1,a2,0x20
    1118:	01c5d713          	srli	a4,a1,0x1c
    111c:	973e                	add	a4,a4,a5
    111e:	fae68ae3          	beq	a3,a4,10d2 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1122:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1124:	00001717          	auipc	a4,0x1
    1128:	eef73623          	sd	a5,-276(a4) # 2010 <freep>
}
    112c:	60a2                	ld	ra,8(sp)
    112e:	6402                	ld	s0,0(sp)
    1130:	0141                	addi	sp,sp,16
    1132:	8082                	ret

0000000000001134 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1134:	7139                	addi	sp,sp,-64
    1136:	fc06                	sd	ra,56(sp)
    1138:	f822                	sd	s0,48(sp)
    113a:	f04a                	sd	s2,32(sp)
    113c:	ec4e                	sd	s3,24(sp)
    113e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1140:	02051993          	slli	s3,a0,0x20
    1144:	0209d993          	srli	s3,s3,0x20
    1148:	09bd                	addi	s3,s3,15
    114a:	0049d993          	srli	s3,s3,0x4
    114e:	2985                	addiw	s3,s3,1
    1150:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1152:	00001517          	auipc	a0,0x1
    1156:	ebe53503          	ld	a0,-322(a0) # 2010 <freep>
    115a:	c905                	beqz	a0,118a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    115c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    115e:	4798                	lw	a4,8(a5)
    1160:	09377663          	bgeu	a4,s3,11ec <malloc+0xb8>
    1164:	f426                	sd	s1,40(sp)
    1166:	e852                	sd	s4,16(sp)
    1168:	e456                	sd	s5,8(sp)
    116a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    116c:	8a4e                	mv	s4,s3
    116e:	6705                	lui	a4,0x1
    1170:	00e9f363          	bgeu	s3,a4,1176 <malloc+0x42>
    1174:	6a05                	lui	s4,0x1
    1176:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    117a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    117e:	00001497          	auipc	s1,0x1
    1182:	e9248493          	addi	s1,s1,-366 # 2010 <freep>
  if(p == (char*)-1)
    1186:	5afd                	li	s5,-1
    1188:	a83d                	j	11c6 <malloc+0x92>
    118a:	f426                	sd	s1,40(sp)
    118c:	e852                	sd	s4,16(sp)
    118e:	e456                	sd	s5,8(sp)
    1190:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1192:	00001797          	auipc	a5,0x1
    1196:	27678793          	addi	a5,a5,630 # 2408 <base>
    119a:	00001717          	auipc	a4,0x1
    119e:	e6f73b23          	sd	a5,-394(a4) # 2010 <freep>
    11a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11a8:	b7d1                	j	116c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11aa:	6398                	ld	a4,0(a5)
    11ac:	e118                	sd	a4,0(a0)
    11ae:	a899                	j	1204 <malloc+0xd0>
  hp->s.size = nu;
    11b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11b4:	0541                	addi	a0,a0,16
    11b6:	ef9ff0ef          	jal	10ae <free>
  return freep;
    11ba:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11bc:	c125                	beqz	a0,121c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11c0:	4798                	lw	a4,8(a5)
    11c2:	03277163          	bgeu	a4,s2,11e4 <malloc+0xb0>
    if(p == freep)
    11c6:	6098                	ld	a4,0(s1)
    11c8:	853e                	mv	a0,a5
    11ca:	fef71ae3          	bne	a4,a5,11be <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11ce:	8552                	mv	a0,s4
    11d0:	af3ff0ef          	jal	cc2 <sbrk>
  if(p == (char*)-1)
    11d4:	fd551ee3          	bne	a0,s5,11b0 <malloc+0x7c>
        return 0;
    11d8:	4501                	li	a0,0
    11da:	74a2                	ld	s1,40(sp)
    11dc:	6a42                	ld	s4,16(sp)
    11de:	6aa2                	ld	s5,8(sp)
    11e0:	6b02                	ld	s6,0(sp)
    11e2:	a03d                	j	1210 <malloc+0xdc>
    11e4:	74a2                	ld	s1,40(sp)
    11e6:	6a42                	ld	s4,16(sp)
    11e8:	6aa2                	ld	s5,8(sp)
    11ea:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11ec:	fae90fe3          	beq	s2,a4,11aa <malloc+0x76>
        p->s.size -= nunits;
    11f0:	4137073b          	subw	a4,a4,s3
    11f4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11f6:	02071693          	slli	a3,a4,0x20
    11fa:	01c6d713          	srli	a4,a3,0x1c
    11fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1200:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1204:	00001717          	auipc	a4,0x1
    1208:	e0a73623          	sd	a0,-500(a4) # 2010 <freep>
      return (void*)(p + 1);
    120c:	01078513          	addi	a0,a5,16
  }
}
    1210:	70e2                	ld	ra,56(sp)
    1212:	7442                	ld	s0,48(sp)
    1214:	7902                	ld	s2,32(sp)
    1216:	69e2                	ld	s3,24(sp)
    1218:	6121                	addi	sp,sp,64
    121a:	8082                	ret
    121c:	74a2                	ld	s1,40(sp)
    121e:	6a42                	ld	s4,16(sp)
    1220:	6aa2                	ld	s5,8(sp)
    1222:	6b02                	ld	s6,0(sp)
    1224:	b7f5                	j	1210 <malloc+0xdc>
