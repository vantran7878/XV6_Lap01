
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	9a278793          	addi	a5,a5,-1630 # 9c0 <malloc+0x126>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	95c50513          	addi	a0,a0,-1700 # 990 <malloc+0xf6>
  3c:	7a6000ef          	jal	7e2 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	12c000ef          	jal	178 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	344000ef          	jal	398 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for(i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	94450513          	addi	a0,a0,-1724 # 9a8 <malloc+0x10e>
  6c:	776000ef          	jal	7e2 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	35e000ef          	jal	3e0 <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	328000ef          	jal	3c0 <write>
  for(i = 0; i < 20; i++)
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	326000ef          	jal	3c8 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	91250513          	addi	a0,a0,-1774 # 9b8 <malloc+0x11e>
  ae:	734000ef          	jal	7e2 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	328000ef          	jal	3e0 <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2ea000ef          	jal	3b8 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	2f0000ef          	jal	3c8 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2ca000ef          	jal	3a8 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2bc000ef          	jal	3a0 <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f0:	f11ff0ef          	jal	0 <main>
  exit(0);
  f4:	4501                	li	a0,0
  f6:	2aa000ef          	jal	3a0 <exit>

00000000000000fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0xa>
    ;
  return os;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 122:	00054783          	lbu	a5,0(a0)
 126:	cb91                	beqz	a5,13a <strcmp+0x20>
 128:	0005c703          	lbu	a4,0(a1)
 12c:	00f71763          	bne	a4,a5,13a <strcmp+0x20>
    p++, q++;
 130:	0505                	addi	a0,a0,1
 132:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	fbe5                	bnez	a5,128 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 13a:	0005c503          	lbu	a0,0(a1)
}
 13e:	40a7853b          	subw	a0,a5,a0
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 152:	00054783          	lbu	a5,0(a0)
 156:	cf99                	beqz	a5,174 <strlen+0x2a>
 158:	0505                	addi	a0,a0,1
 15a:	87aa                	mv	a5,a0
 15c:	86be                	mv	a3,a5
 15e:	0785                	addi	a5,a5,1
 160:	fff7c703          	lbu	a4,-1(a5)
 164:	ff65                	bnez	a4,15c <strlen+0x12>
 166:	40a6853b          	subw	a0,a3,a0
 16a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret
  for(n = 0; s[n]; n++)
 174:	4501                	li	a0,0
 176:	bfdd                	j	16c <strlen+0x22>

0000000000000178 <memset>:

void*
memset(void *dst, int c, uint n)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 180:	ca19                	beqz	a2,196 <memset+0x1e>
 182:	87aa                	mv	a5,a0
 184:	1602                	slli	a2,a2,0x20
 186:	9201                	srli	a2,a2,0x20
 188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 190:	0785                	addi	a5,a5,1
 192:	fee79de3          	bne	a5,a4,18c <memset+0x14>
  }
  return dst;
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret

000000000000019e <strchr>:

char*
strchr(const char *s, char c)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cf81                	beqz	a5,1c2 <strchr+0x24>
    if(*s == c)
 1ac:	00f58763          	beq	a1,a5,1ba <strchr+0x1c>
  for(; *s; s++)
 1b0:	0505                	addi	a0,a0,1
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbfd                	bnez	a5,1ac <strchr+0xe>
      return (char*)s;
  return 0;
 1b8:	4501                	li	a0,0
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret
  return 0;
 1c2:	4501                	li	a0,0
 1c4:	bfdd                	j	1ba <strchr+0x1c>

00000000000001c6 <gets>:

char*
gets(char *buf, int max)
{
 1c6:	7159                	addi	sp,sp,-112
 1c8:	f486                	sd	ra,104(sp)
 1ca:	f0a2                	sd	s0,96(sp)
 1cc:	eca6                	sd	s1,88(sp)
 1ce:	e8ca                	sd	s2,80(sp)
 1d0:	e4ce                	sd	s3,72(sp)
 1d2:	e0d2                	sd	s4,64(sp)
 1d4:	fc56                	sd	s5,56(sp)
 1d6:	f85a                	sd	s6,48(sp)
 1d8:	f45e                	sd	s7,40(sp)
 1da:	f062                	sd	s8,32(sp)
 1dc:	ec66                	sd	s9,24(sp)
 1de:	e86a                	sd	s10,16(sp)
 1e0:	1880                	addi	s0,sp,112
 1e2:	8caa                	mv	s9,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ea:	f9f40b13          	addi	s6,s0,-97
 1ee:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f0:	4ba9                	li	s7,10
 1f2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1f4:	8d26                	mv	s10,s1
 1f6:	0014899b          	addiw	s3,s1,1
 1fa:	84ce                	mv	s1,s3
 1fc:	0349d563          	bge	s3,s4,226 <gets+0x60>
    cc = read(0, &c, 1);
 200:	8656                	mv	a2,s5
 202:	85da                	mv	a1,s6
 204:	4501                	li	a0,0
 206:	1b2000ef          	jal	3b8 <read>
    if(cc < 1)
 20a:	00a05e63          	blez	a0,226 <gets+0x60>
    buf[i++] = c;
 20e:	f9f44783          	lbu	a5,-97(s0)
 212:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 216:	01778763          	beq	a5,s7,224 <gets+0x5e>
 21a:	0905                	addi	s2,s2,1
 21c:	fd879ce3          	bne	a5,s8,1f4 <gets+0x2e>
    buf[i++] = c;
 220:	8d4e                	mv	s10,s3
 222:	a011                	j	226 <gets+0x60>
 224:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 226:	9d66                	add	s10,s10,s9
 228:	000d0023          	sb	zero,0(s10)
  return buf;
}
 22c:	8566                	mv	a0,s9
 22e:	70a6                	ld	ra,104(sp)
 230:	7406                	ld	s0,96(sp)
 232:	64e6                	ld	s1,88(sp)
 234:	6946                	ld	s2,80(sp)
 236:	69a6                	ld	s3,72(sp)
 238:	6a06                	ld	s4,64(sp)
 23a:	7ae2                	ld	s5,56(sp)
 23c:	7b42                	ld	s6,48(sp)
 23e:	7ba2                	ld	s7,40(sp)
 240:	7c02                	ld	s8,32(sp)
 242:	6ce2                	ld	s9,24(sp)
 244:	6d42                	ld	s10,16(sp)
 246:	6165                	addi	sp,sp,112
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e04a                	sd	s2,0(sp)
 252:	1000                	addi	s0,sp,32
 254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	4581                	li	a1,0
 258:	188000ef          	jal	3e0 <open>
  if(fd < 0)
 25c:	02054263          	bltz	a0,280 <stat+0x36>
 260:	e426                	sd	s1,8(sp)
 262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 264:	85ca                	mv	a1,s2
 266:	192000ef          	jal	3f8 <fstat>
 26a:	892a                	mv	s2,a0
  close(fd);
 26c:	8526                	mv	a0,s1
 26e:	15a000ef          	jal	3c8 <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfcd                	j	274 <stat+0x2a>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66963          	bltu	a2,a5,2cc <atoi+0x48>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a2:	0705                	addi	a4,a4,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1e>
  return n;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  n = 0;
 2cc:	4501                	li	a0,0
 2ce:	bfdd                	j	2c4 <atoi+0x40>

00000000000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d8:	02b57563          	bgeu	a0,a1,302 <memmove+0x32>
    while(n-- > 0)
 2dc:	00c05f63          	blez	a2,2fa <memmove+0x2a>
 2e0:	1602                	slli	a2,a2,0x20
 2e2:	9201                	srli	a2,a2,0x20
 2e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ea:	0585                	addi	a1,a1,1
 2ec:	0705                	addi	a4,a4,1
 2ee:	fff5c683          	lbu	a3,-1(a1)
 2f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
    dst += n;
 302:	00c50733          	add	a4,a0,a2
    src += n;
 306:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 308:	fec059e3          	blez	a2,2fa <memmove+0x2a>
 30c:	fff6079b          	addiw	a5,a2,-1
 310:	1782                	slli	a5,a5,0x20
 312:	9381                	srli	a5,a5,0x20
 314:	fff7c793          	not	a5,a5
 318:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31a:	15fd                	addi	a1,a1,-1
 31c:	177d                	addi	a4,a4,-1
 31e:	0005c683          	lbu	a3,0(a1)
 322:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 326:	fef71ae3          	bne	a4,a5,31a <memmove+0x4a>
 32a:	bfc1                	j	2fa <memmove+0x2a>

000000000000032c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	ca0d                	beqz	a2,366 <memcmp+0x3a>
 336:	fff6069b          	addiw	a3,a2,-1
 33a:	1682                	slli	a3,a3,0x20
 33c:	9281                	srli	a3,a3,0x20
 33e:	0685                	addi	a3,a3,1
 340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	addi	a0,a0,1
    p2++;
 350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x16>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x32>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfdd                	j	35e <memcmp+0x32>

000000000000036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 372:	f5fff0ef          	jal	2d0 <memmove>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 386:	040007b7          	lui	a5,0x4000
 38a:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 38c:	07b2                	slli	a5,a5,0xc
}
 38e:	4388                	lw	a0,0(a5)
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 398:	4885                	li	a7,1
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a0:	4889                	li	a7,2
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a8:	488d                	li	a7,3
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b0:	4891                	li	a7,4
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <write>:
.global write
write:
 li a7, SYS_write
 3c0:	48c1                	li	a7,16
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <close>:
.global close
close:
 li a7, SYS_close
 3c8:	48d5                	li	a7,21
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d0:	4899                	li	a7,6
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	489d                	li	a7,7
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <open>:
.global open
open:
 li a7, SYS_open
 3e0:	48bd                	li	a7,15
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e8:	48c5                	li	a7,17
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f0:	48c9                	li	a7,18
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f8:	48a1                	li	a7,8
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <link>:
.global link
link:
 li a7, SYS_link
 400:	48cd                	li	a7,19
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 408:	48d1                	li	a7,20
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 410:	48a5                	li	a7,9
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <dup>:
.global dup
dup:
 li a7, SYS_dup
 418:	48a9                	li	a7,10
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 420:	48ad                	li	a7,11
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 428:	48b1                	li	a7,12
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 430:	48b5                	li	a7,13
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 438:	48b9                	li	a7,14
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <bind>:
.global bind
bind:
 li a7, SYS_bind
 440:	48f5                	li	a7,29
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 448:	48f9                	li	a7,30
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <send>:
.global send
send:
 li a7, SYS_send
 450:	48fd                	li	a7,31
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <recv>:
.global recv
recv:
 li a7, SYS_recv
 458:	02000893          	li	a7,32
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 462:	02100893          	li	a7,33
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 46c:	02200893          	li	a7,34
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 476:	02400893          	li	a7,36
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 480:	1101                	addi	sp,sp,-32
 482:	ec06                	sd	ra,24(sp)
 484:	e822                	sd	s0,16(sp)
 486:	1000                	addi	s0,sp,32
 488:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48c:	4605                	li	a2,1
 48e:	fef40593          	addi	a1,s0,-17
 492:	f2fff0ef          	jal	3c0 <write>
}
 496:	60e2                	ld	ra,24(sp)
 498:	6442                	ld	s0,16(sp)
 49a:	6105                	addi	sp,sp,32
 49c:	8082                	ret

000000000000049e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49e:	7139                	addi	sp,sp,-64
 4a0:	fc06                	sd	ra,56(sp)
 4a2:	f822                	sd	s0,48(sp)
 4a4:	f426                	sd	s1,40(sp)
 4a6:	f04a                	sd	s2,32(sp)
 4a8:	ec4e                	sd	s3,24(sp)
 4aa:	0080                	addi	s0,sp,64
 4ac:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ae:	c299                	beqz	a3,4b4 <printint+0x16>
 4b0:	0605ce63          	bltz	a1,52c <printint+0x8e>
  neg = 0;
 4b4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4b6:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4ba:	869a                	mv	a3,t1
  i = 0;
 4bc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4be:	00000817          	auipc	a6,0x0
 4c2:	51a80813          	addi	a6,a6,1306 # 9d8 <digits>
 4c6:	88be                	mv	a7,a5
 4c8:	0017851b          	addiw	a0,a5,1
 4cc:	87aa                	mv	a5,a0
 4ce:	02c5f73b          	remuw	a4,a1,a2
 4d2:	1702                	slli	a4,a4,0x20
 4d4:	9301                	srli	a4,a4,0x20
 4d6:	9742                	add	a4,a4,a6
 4d8:	00074703          	lbu	a4,0(a4)
 4dc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4e0:	872e                	mv	a4,a1
 4e2:	02c5d5bb          	divuw	a1,a1,a2
 4e6:	0685                	addi	a3,a3,1
 4e8:	fcc77fe3          	bgeu	a4,a2,4c6 <printint+0x28>
  if(neg)
 4ec:	000e0c63          	beqz	t3,504 <printint+0x66>
    buf[i++] = '-';
 4f0:	fd050793          	addi	a5,a0,-48
 4f4:	00878533          	add	a0,a5,s0
 4f8:	02d00793          	li	a5,45
 4fc:	fef50823          	sb	a5,-16(a0)
 500:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 504:	fff7899b          	addiw	s3,a5,-1
 508:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 50c:	fff4c583          	lbu	a1,-1(s1)
 510:	854a                	mv	a0,s2
 512:	f6fff0ef          	jal	480 <putc>
  while(--i >= 0)
 516:	39fd                	addiw	s3,s3,-1
 518:	14fd                	addi	s1,s1,-1
 51a:	fe09d9e3          	bgez	s3,50c <printint+0x6e>
}
 51e:	70e2                	ld	ra,56(sp)
 520:	7442                	ld	s0,48(sp)
 522:	74a2                	ld	s1,40(sp)
 524:	7902                	ld	s2,32(sp)
 526:	69e2                	ld	s3,24(sp)
 528:	6121                	addi	sp,sp,64
 52a:	8082                	ret
    x = -xx;
 52c:	40b005bb          	negw	a1,a1
    neg = 1;
 530:	4e05                	li	t3,1
    x = -xx;
 532:	b751                	j	4b6 <printint+0x18>

0000000000000534 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 534:	711d                	addi	sp,sp,-96
 536:	ec86                	sd	ra,88(sp)
 538:	e8a2                	sd	s0,80(sp)
 53a:	e4a6                	sd	s1,72(sp)
 53c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53e:	0005c483          	lbu	s1,0(a1)
 542:	26048663          	beqz	s1,7ae <vprintf+0x27a>
 546:	e0ca                	sd	s2,64(sp)
 548:	fc4e                	sd	s3,56(sp)
 54a:	f852                	sd	s4,48(sp)
 54c:	f456                	sd	s5,40(sp)
 54e:	f05a                	sd	s6,32(sp)
 550:	ec5e                	sd	s7,24(sp)
 552:	e862                	sd	s8,16(sp)
 554:	e466                	sd	s9,8(sp)
 556:	8b2a                	mv	s6,a0
 558:	8a2e                	mv	s4,a1
 55a:	8bb2                	mv	s7,a2
  state = 0;
 55c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 55e:	4901                	li	s2,0
 560:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 562:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 566:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 56a:	06c00c93          	li	s9,108
 56e:	a00d                	j	590 <vprintf+0x5c>
        putc(fd, c0);
 570:	85a6                	mv	a1,s1
 572:	855a                	mv	a0,s6
 574:	f0dff0ef          	jal	480 <putc>
 578:	a019                	j	57e <vprintf+0x4a>
    } else if(state == '%'){
 57a:	03598363          	beq	s3,s5,5a0 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 57e:	0019079b          	addiw	a5,s2,1
 582:	893e                	mv	s2,a5
 584:	873e                	mv	a4,a5
 586:	97d2                	add	a5,a5,s4
 588:	0007c483          	lbu	s1,0(a5)
 58c:	20048963          	beqz	s1,79e <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 590:	0004879b          	sext.w	a5,s1
    if(state == 0){
 594:	fe0993e3          	bnez	s3,57a <vprintf+0x46>
      if(c0 == '%'){
 598:	fd579ce3          	bne	a5,s5,570 <vprintf+0x3c>
        state = '%';
 59c:	89be                	mv	s3,a5
 59e:	b7c5                	j	57e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a0:	00ea06b3          	add	a3,s4,a4
 5a4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5a8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5aa:	c681                	beqz	a3,5b2 <vprintf+0x7e>
 5ac:	9752                	add	a4,a4,s4
 5ae:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5b2:	03878e63          	beq	a5,s8,5ee <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5b6:	05978863          	beq	a5,s9,606 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ba:	07500713          	li	a4,117
 5be:	0ee78263          	beq	a5,a4,6a2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5c2:	07800713          	li	a4,120
 5c6:	12e78463          	beq	a5,a4,6ee <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ca:	07000713          	li	a4,112
 5ce:	14e78963          	beq	a5,a4,720 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5d2:	07300713          	li	a4,115
 5d6:	18e78863          	beq	a5,a4,766 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5da:	02500713          	li	a4,37
 5de:	04e79463          	bne	a5,a4,626 <vprintf+0xf2>
        putc(fd, '%');
 5e2:	85ba                	mv	a1,a4
 5e4:	855a                	mv	a0,s6
 5e6:	e9bff0ef          	jal	480 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bf49                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4685                	li	a3,1
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	ea3ff0ef          	jal	49e <printint>
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
 604:	bfad                	j	57e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 606:	06400793          	li	a5,100
 60a:	02f68963          	beq	a3,a5,63c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60e:	06c00793          	li	a5,108
 612:	04f68263          	beq	a3,a5,656 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 616:	07500793          	li	a5,117
 61a:	0af68063          	beq	a3,a5,6ba <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 61e:	07800793          	li	a5,120
 622:	0ef68263          	beq	a3,a5,706 <vprintf+0x1d2>
        putc(fd, '%');
 626:	02500593          	li	a1,37
 62a:	855a                	mv	a0,s6
 62c:	e55ff0ef          	jal	480 <putc>
        putc(fd, c0);
 630:	85a6                	mv	a1,s1
 632:	855a                	mv	a0,s6
 634:	e4dff0ef          	jal	480 <putc>
      state = 0;
 638:	4981                	li	s3,0
 63a:	b791                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	008b8493          	addi	s1,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e55ff0ef          	jal	49e <printint>
        i += 1;
 64e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 1;
 654:	b72d                	j	57e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 656:	06400793          	li	a5,100
 65a:	02f60763          	beq	a2,a5,688 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65e:	07500793          	li	a5,117
 662:	06f60963          	beq	a2,a5,6d4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 666:	07800793          	li	a5,120
 66a:	faf61ee3          	bne	a2,a5,626 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	e23ff0ef          	jal	49e <printint>
        i += 2;
 680:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	bde5                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	008b8493          	addi	s1,s7,8
 68c:	4685                	li	a3,1
 68e:	4629                	li	a2,10
 690:	000ba583          	lw	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	e09ff0ef          	jal	49e <printint>
        i += 2;
 69a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	bdf9                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6a2:	008b8493          	addi	s1,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4629                	li	a2,10
 6aa:	000ba583          	lw	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	defff0ef          	jal	49e <printint>
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b5d9                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000ba583          	lw	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	dd7ff0ef          	jal	49e <printint>
        i += 1;
 6cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
        i += 1;
 6d2:	b575                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4681                	li	a3,0
 6da:	4629                	li	a2,10
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	dbdff0ef          	jal	49e <printint>
        i += 2;
 6e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	8ba6                	mv	s7,s1
      state = 0;
 6ea:	4981                	li	s3,0
        i += 2;
 6ec:	bd49                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6ee:	008b8493          	addi	s1,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4641                	li	a2,16
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	da3ff0ef          	jal	49e <printint>
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	bdad                	j	57e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	008b8493          	addi	s1,s7,8
 70a:	4681                	li	a3,0
 70c:	4641                	li	a2,16
 70e:	000ba583          	lw	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	d8bff0ef          	jal	49e <printint>
        i += 1;
 718:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71a:	8ba6                	mv	s7,s1
      state = 0;
 71c:	4981                	li	s3,0
        i += 1;
 71e:	b585                	j	57e <vprintf+0x4a>
 720:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 722:	008b8d13          	addi	s10,s7,8
 726:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72a:	03000593          	li	a1,48
 72e:	855a                	mv	a0,s6
 730:	d51ff0ef          	jal	480 <putc>
  putc(fd, 'x');
 734:	07800593          	li	a1,120
 738:	855a                	mv	a0,s6
 73a:	d47ff0ef          	jal	480 <putc>
 73e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 740:	00000b97          	auipc	s7,0x0
 744:	298b8b93          	addi	s7,s7,664 # 9d8 <digits>
 748:	03c9d793          	srli	a5,s3,0x3c
 74c:	97de                	add	a5,a5,s7
 74e:	0007c583          	lbu	a1,0(a5)
 752:	855a                	mv	a0,s6
 754:	d2dff0ef          	jal	480 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 758:	0992                	slli	s3,s3,0x4
 75a:	34fd                	addiw	s1,s1,-1
 75c:	f4f5                	bnez	s1,748 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 75e:	8bea                	mv	s7,s10
      state = 0;
 760:	4981                	li	s3,0
 762:	6d02                	ld	s10,0(sp)
 764:	bd29                	j	57e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 766:	008b8993          	addi	s3,s7,8
 76a:	000bb483          	ld	s1,0(s7)
 76e:	cc91                	beqz	s1,78a <vprintf+0x256>
        for(; *s; s++)
 770:	0004c583          	lbu	a1,0(s1)
 774:	c195                	beqz	a1,798 <vprintf+0x264>
          putc(fd, *s);
 776:	855a                	mv	a0,s6
 778:	d09ff0ef          	jal	480 <putc>
        for(; *s; s++)
 77c:	0485                	addi	s1,s1,1
 77e:	0004c583          	lbu	a1,0(s1)
 782:	f9f5                	bnez	a1,776 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 784:	8bce                	mv	s7,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	bbdd                	j	57e <vprintf+0x4a>
          s = "(null)";
 78a:	00000497          	auipc	s1,0x0
 78e:	24648493          	addi	s1,s1,582 # 9d0 <malloc+0x136>
        for(; *s; s++)
 792:	02800593          	li	a1,40
 796:	b7c5                	j	776 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b3cd                	j	57e <vprintf+0x4a>
 79e:	6906                	ld	s2,64(sp)
 7a0:	79e2                	ld	s3,56(sp)
 7a2:	7a42                	ld	s4,48(sp)
 7a4:	7aa2                	ld	s5,40(sp)
 7a6:	7b02                	ld	s6,32(sp)
 7a8:	6be2                	ld	s7,24(sp)
 7aa:	6c42                	ld	s8,16(sp)
 7ac:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7ae:	60e6                	ld	ra,88(sp)
 7b0:	6446                	ld	s0,80(sp)
 7b2:	64a6                	ld	s1,72(sp)
 7b4:	6125                	addi	sp,sp,96
 7b6:	8082                	ret

00000000000007b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b8:	715d                	addi	sp,sp,-80
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e010                	sd	a2,0(s0)
 7c2:	e414                	sd	a3,8(s0)
 7c4:	e818                	sd	a4,16(s0)
 7c6:	ec1c                	sd	a5,24(s0)
 7c8:	03043023          	sd	a6,32(s0)
 7cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	8622                	mv	a2,s0
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	d5fff0ef          	jal	534 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	addi	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	addi	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	d2dff0ef          	jal	534 <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6125                	addi	sp,sp,96
 812:	8082                	ret

0000000000000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	1141                	addi	sp,sp,-16
 816:	e406                	sd	ra,8(sp)
 818:	e022                	sd	s0,0(sp)
 81a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	00000797          	auipc	a5,0x0
 824:	7e07b783          	ld	a5,2016(a5) # 1000 <freep>
 828:	a02d                	j	852 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82a:	4618                	lw	a4,8(a2)
 82c:	9f2d                	addw	a4,a4,a1
 82e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	6398                	ld	a4,0(a5)
 834:	6310                	ld	a2,0(a4)
 836:	a83d                	j	874 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 838:	ff852703          	lw	a4,-8(a0)
 83c:	9f31                	addw	a4,a4,a2
 83e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 840:	ff053683          	ld	a3,-16(a0)
 844:	a091                	j	888 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	6398                	ld	a4,0(a5)
 848:	00e7e463          	bltu	a5,a4,850 <free+0x3c>
 84c:	00e6ea63          	bltu	a3,a4,860 <free+0x4c>
{
 850:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 852:	fed7fae3          	bgeu	a5,a3,846 <free+0x32>
 856:	6398                	ld	a4,0(a5)
 858:	00e6e463          	bltu	a3,a4,860 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	fee7eae3          	bltu	a5,a4,850 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 860:	ff852583          	lw	a1,-8(a0)
 864:	6390                	ld	a2,0(a5)
 866:	02059813          	slli	a6,a1,0x20
 86a:	01c85713          	srli	a4,a6,0x1c
 86e:	9736                	add	a4,a4,a3
 870:	fae60de3          	beq	a2,a4,82a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 878:	4790                	lw	a2,8(a5)
 87a:	02061593          	slli	a1,a2,0x20
 87e:	01c5d713          	srli	a4,a1,0x1c
 882:	973e                	add	a4,a4,a5
 884:	fae68ae3          	beq	a3,a4,838 <free+0x24>
    p->s.ptr = bp->s.ptr;
 888:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88a:	00000717          	auipc	a4,0x0
 88e:	76f73b23          	sd	a5,1910(a4) # 1000 <freep>
}
 892:	60a2                	ld	ra,8(sp)
 894:	6402                	ld	s0,0(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret

000000000000089a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89a:	7139                	addi	sp,sp,-64
 89c:	fc06                	sd	ra,56(sp)
 89e:	f822                	sd	s0,48(sp)
 8a0:	f04a                	sd	s2,32(sp)
 8a2:	ec4e                	sd	s3,24(sp)
 8a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	02051993          	slli	s3,a0,0x20
 8aa:	0209d993          	srli	s3,s3,0x20
 8ae:	09bd                	addi	s3,s3,15
 8b0:	0049d993          	srli	s3,s3,0x4
 8b4:	2985                	addiw	s3,s3,1
 8b6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8b8:	00000517          	auipc	a0,0x0
 8bc:	74853503          	ld	a0,1864(a0) # 1000 <freep>
 8c0:	c905                	beqz	a0,8f0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	09377663          	bgeu	a4,s3,952 <malloc+0xb8>
 8ca:	f426                	sd	s1,40(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8d2:	8a4e                	mv	s4,s3
 8d4:	6705                	lui	a4,0x1
 8d6:	00e9f363          	bgeu	s3,a4,8dc <malloc+0x42>
 8da:	6a05                	lui	s4,0x1
 8dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e4:	00000497          	auipc	s1,0x0
 8e8:	71c48493          	addi	s1,s1,1820 # 1000 <freep>
  if(p == (char*)-1)
 8ec:	5afd                	li	s5,-1
 8ee:	a83d                	j	92c <malloc+0x92>
 8f0:	f426                	sd	s1,40(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	71878793          	addi	a5,a5,1816 # 1010 <base>
 900:	00000717          	auipc	a4,0x0
 904:	70f73023          	sd	a5,1792(a4) # 1000 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7d1                	j	8d2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 910:	6398                	ld	a4,0(a5)
 912:	e118                	sd	a4,0(a0)
 914:	a899                	j	96a <malloc+0xd0>
  hp->s.size = nu;
 916:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91a:	0541                	addi	a0,a0,16
 91c:	ef9ff0ef          	jal	814 <free>
  return freep;
 920:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 922:	c125                	beqz	a0,982 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 926:	4798                	lw	a4,8(a5)
 928:	03277163          	bgeu	a4,s2,94a <malloc+0xb0>
    if(p == freep)
 92c:	6098                	ld	a4,0(s1)
 92e:	853e                	mv	a0,a5
 930:	fef71ae3          	bne	a4,a5,924 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 934:	8552                	mv	a0,s4
 936:	af3ff0ef          	jal	428 <sbrk>
  if(p == (char*)-1)
 93a:	fd551ee3          	bne	a0,s5,916 <malloc+0x7c>
        return 0;
 93e:	4501                	li	a0,0
 940:	74a2                	ld	s1,40(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	a03d                	j	976 <malloc+0xdc>
 94a:	74a2                	ld	s1,40(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 952:	fae90fe3          	beq	s2,a4,910 <malloc+0x76>
        p->s.size -= nunits;
 956:	4137073b          	subw	a4,a4,s3
 95a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95c:	02071693          	slli	a3,a4,0x20
 960:	01c6d713          	srli	a4,a3,0x1c
 964:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 966:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96a:	00000717          	auipc	a4,0x0
 96e:	68a73b23          	sd	a0,1686(a4) # 1000 <freep>
      return (void*)(p + 1);
 972:	01078513          	addi	a0,a5,16
  }
}
 976:	70e2                	ld	ra,56(sp)
 978:	7442                	ld	s0,48(sp)
 97a:	7902                	ld	s2,32(sp)
 97c:	69e2                	ld	s3,24(sp)
 97e:	6121                	addi	sp,sp,64
 980:	8082                	ret
 982:	74a2                	ld	s1,40(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
 98a:	b7f5                	j	976 <malloc+0xdc>
