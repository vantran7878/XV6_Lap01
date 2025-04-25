
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	9c4a0a13          	addi	s4,s4,-1596 # a00 <malloc+0xf2>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1ca000ef          	jal	212 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866a                	mv	a2,s10
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	3b4000ef          	jal	42c <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	98250513          	addi	a0,a0,-1662 # a20 <malloc+0x112>
  a6:	7b0000ef          	jal	856 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	94850513          	addi	a0,a0,-1720 # a10 <malloc+0x102>
  d0:	786000ef          	jal	856 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	33e000ef          	jal	414 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	34c000ef          	jal	454 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	320000ef          	jal	43c <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ec000ef          	jal	414 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8d658593          	addi	a1,a1,-1834 # a08 <malloc+0xfa>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d2000ef          	jal	414 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8e650513          	addi	a0,a0,-1818 # a30 <malloc+0x122>
 152:	704000ef          	jal	856 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2bc000ef          	jal	414 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	2aa000ef          	jal	414 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	addi	a1,a1,1
 17a:	0785                	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0xa>
    ;
  return os;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x20>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x20>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cf99                	beqz	a5,1e8 <strlen+0x2a>
 1cc:	0505                	addi	a0,a0,1
 1ce:	87aa                	mv	a5,a0
 1d0:	86be                	mv	a3,a5
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff7c703          	lbu	a4,-1(a5)
 1d8:	ff65                	bnez	a4,1d0 <strlen+0x12>
 1da:	40a6853b          	subw	a0,a3,a0
 1de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1e0:	60a2                	ld	ra,8(sp)
 1e2:	6402                	ld	s0,0(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  for(n = 0; s[n]; n++)
 1e8:	4501                	li	a0,0
 1ea:	bfdd                	j	1e0 <strlen+0x22>

00000000000001ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f4:	ca19                	beqz	a2,20a <memset+0x1e>
 1f6:	87aa                	mv	a5,a0
 1f8:	1602                	slli	a2,a2,0x20
 1fa:	9201                	srli	a2,a2,0x20
 1fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 200:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 204:	0785                	addi	a5,a5,1
 206:	fee79de3          	bne	a5,a4,200 <memset+0x14>
  }
  return dst;
}
 20a:	60a2                	ld	ra,8(sp)
 20c:	6402                	ld	s0,0(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strchr>:

char*
strchr(const char *s, char c)
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cf81                	beqz	a5,236 <strchr+0x24>
    if(*s == c)
 220:	00f58763          	beq	a1,a5,22e <strchr+0x1c>
  for(; *s; s++)
 224:	0505                	addi	a0,a0,1
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbfd                	bnez	a5,220 <strchr+0xe>
      return (char*)s;
  return 0;
 22c:	4501                	li	a0,0
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  return 0;
 236:	4501                	li	a0,0
 238:	bfdd                	j	22e <strchr+0x1c>

000000000000023a <gets>:

char*
gets(char *buf, int max)
{
 23a:	7159                	addi	sp,sp,-112
 23c:	f486                	sd	ra,104(sp)
 23e:	f0a2                	sd	s0,96(sp)
 240:	eca6                	sd	s1,88(sp)
 242:	e8ca                	sd	s2,80(sp)
 244:	e4ce                	sd	s3,72(sp)
 246:	e0d2                	sd	s4,64(sp)
 248:	fc56                	sd	s5,56(sp)
 24a:	f85a                	sd	s6,48(sp)
 24c:	f45e                	sd	s7,40(sp)
 24e:	f062                	sd	s8,32(sp)
 250:	ec66                	sd	s9,24(sp)
 252:	e86a                	sd	s10,16(sp)
 254:	1880                	addi	s0,sp,112
 256:	8caa                	mv	s9,a0
 258:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	892a                	mv	s2,a0
 25c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 25e:	f9f40b13          	addi	s6,s0,-97
 262:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 264:	4ba9                	li	s7,10
 266:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 268:	8d26                	mv	s10,s1
 26a:	0014899b          	addiw	s3,s1,1
 26e:	84ce                	mv	s1,s3
 270:	0349d563          	bge	s3,s4,29a <gets+0x60>
    cc = read(0, &c, 1);
 274:	8656                	mv	a2,s5
 276:	85da                	mv	a1,s6
 278:	4501                	li	a0,0
 27a:	1b2000ef          	jal	42c <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x60>
    buf[i++] = c;
 282:	f9f44783          	lbu	a5,-97(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01778763          	beq	a5,s7,298 <gets+0x5e>
 28e:	0905                	addi	s2,s2,1
 290:	fd879ce3          	bne	a5,s8,268 <gets+0x2e>
    buf[i++] = c;
 294:	8d4e                	mv	s10,s3
 296:	a011                	j	29a <gets+0x60>
 298:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 29a:	9d66                	add	s10,s10,s9
 29c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2a0:	8566                	mv	a0,s9
 2a2:	70a6                	ld	ra,104(sp)
 2a4:	7406                	ld	s0,96(sp)
 2a6:	64e6                	ld	s1,88(sp)
 2a8:	6946                	ld	s2,80(sp)
 2aa:	69a6                	ld	s3,72(sp)
 2ac:	6a06                	ld	s4,64(sp)
 2ae:	7ae2                	ld	s5,56(sp)
 2b0:	7b42                	ld	s6,48(sp)
 2b2:	7ba2                	ld	s7,40(sp)
 2b4:	7c02                	ld	s8,32(sp)
 2b6:	6ce2                	ld	s9,24(sp)
 2b8:	6d42                	ld	s10,16(sp)
 2ba:	6165                	addi	sp,sp,112
 2bc:	8082                	ret

00000000000002be <stat>:

int
stat(const char *n, struct stat *st)
{
 2be:	1101                	addi	sp,sp,-32
 2c0:	ec06                	sd	ra,24(sp)
 2c2:	e822                	sd	s0,16(sp)
 2c4:	e04a                	sd	s2,0(sp)
 2c6:	1000                	addi	s0,sp,32
 2c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ca:	4581                	li	a1,0
 2cc:	188000ef          	jal	454 <open>
  if(fd < 0)
 2d0:	02054263          	bltz	a0,2f4 <stat+0x36>
 2d4:	e426                	sd	s1,8(sp)
 2d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d8:	85ca                	mv	a1,s2
 2da:	192000ef          	jal	46c <fstat>
 2de:	892a                	mv	s2,a0
  close(fd);
 2e0:	8526                	mv	a0,s1
 2e2:	15a000ef          	jal	43c <close>
  return r;
 2e6:	64a2                	ld	s1,8(sp)
}
 2e8:	854a                	mv	a0,s2
 2ea:	60e2                	ld	ra,24(sp)
 2ec:	6442                	ld	s0,16(sp)
 2ee:	6902                	ld	s2,0(sp)
 2f0:	6105                	addi	sp,sp,32
 2f2:	8082                	ret
    return -1;
 2f4:	597d                	li	s2,-1
 2f6:	bfcd                	j	2e8 <stat+0x2a>

00000000000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 300:	00054683          	lbu	a3,0(a0)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	4625                	li	a2,9
 30e:	02f66963          	bltu	a2,a5,340 <atoi+0x48>
 312:	872a                	mv	a4,a0
  n = 0;
 314:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 316:	0705                	addi	a4,a4,1
 318:	0025179b          	slliw	a5,a0,0x2
 31c:	9fa9                	addw	a5,a5,a0
 31e:	0017979b          	slliw	a5,a5,0x1
 322:	9fb5                	addw	a5,a5,a3
 324:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 328:	00074683          	lbu	a3,0(a4)
 32c:	fd06879b          	addiw	a5,a3,-48
 330:	0ff7f793          	zext.b	a5,a5
 334:	fef671e3          	bgeu	a2,a5,316 <atoi+0x1e>
  return n;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  n = 0;
 340:	4501                	li	a0,0
 342:	bfdd                	j	338 <atoi+0x40>

0000000000000344 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57563          	bgeu	a0,a1,376 <memmove+0x32>
    while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x2a>
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	872a                	mv	a4,a0
      *dst++ = *src++;
 35e:	0585                	addi	a1,a1,1
 360:	0705                	addi	a4,a4,1
 362:	fff5c683          	lbu	a3,-1(a1)
 366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
    dst += n;
 376:	00c50733          	add	a4,a0,a2
    src += n;
 37a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37c:	fec059e3          	blez	a2,36e <memmove+0x2a>
 380:	fff6079b          	addiw	a5,a2,-1
 384:	1782                	slli	a5,a5,0x20
 386:	9381                	srli	a5,a5,0x20
 388:	fff7c793          	not	a5,a5
 38c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38e:	15fd                	addi	a1,a1,-1
 390:	177d                	addi	a4,a4,-1
 392:	0005c683          	lbu	a3,0(a1)
 396:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39a:	fef71ae3          	bne	a4,a5,38e <memmove+0x4a>
 39e:	bfc1                	j	36e <memmove+0x2a>

00000000000003a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a8:	ca0d                	beqz	a2,3da <memcmp+0x3a>
 3aa:	fff6069b          	addiw	a3,a2,-1
 3ae:	1682                	slli	a3,a3,0x20
 3b0:	9281                	srli	a3,a3,0x20
 3b2:	0685                	addi	a3,a3,1
 3b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	0005c703          	lbu	a4,0(a1)
 3be:	00e79863          	bne	a5,a4,3ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3c2:	0505                	addi	a0,a0,1
    p2++;
 3c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c6:	fed518e3          	bne	a0,a3,3b6 <memcmp+0x16>
  }
  return 0;
 3ca:	4501                	li	a0,0
 3cc:	a019                	j	3d2 <memcmp+0x32>
      return *p1 - *p2;
 3ce:	40e7853b          	subw	a0,a5,a4
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfdd                	j	3d2 <memcmp+0x32>

00000000000003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e6:	f5fff0ef          	jal	344 <memmove>
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e406                	sd	ra,8(sp)
 3f6:	e022                	sd	s0,0(sp)
 3f8:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 3fa:	040007b7          	lui	a5,0x4000
 3fe:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffeded>
 400:	07b2                	slli	a5,a5,0xc
}
 402:	4388                	lw	a0,0(a5)
 404:	60a2                	ld	ra,8(sp)
 406:	6402                	ld	s0,0(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret

000000000000040c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40c:	4885                	li	a7,1
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exit>:
.global exit
exit:
 li a7, SYS_exit
 414:	4889                	li	a7,2
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <wait>:
.global wait
wait:
 li a7, SYS_wait
 41c:	488d                	li	a7,3
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 424:	4891                	li	a7,4
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <read>:
.global read
read:
 li a7, SYS_read
 42c:	4895                	li	a7,5
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <write>:
.global write
write:
 li a7, SYS_write
 434:	48c1                	li	a7,16
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <close>:
.global close
close:
 li a7, SYS_close
 43c:	48d5                	li	a7,21
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <kill>:
.global kill
kill:
 li a7, SYS_kill
 444:	4899                	li	a7,6
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exec>:
.global exec
exec:
 li a7, SYS_exec
 44c:	489d                	li	a7,7
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <open>:
.global open
open:
 li a7, SYS_open
 454:	48bd                	li	a7,15
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45c:	48c5                	li	a7,17
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 464:	48c9                	li	a7,18
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46c:	48a1                	li	a7,8
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <link>:
.global link
link:
 li a7, SYS_link
 474:	48cd                	li	a7,19
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47c:	48d1                	li	a7,20
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 484:	48a5                	li	a7,9
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <dup>:
.global dup
dup:
 li a7, SYS_dup
 48c:	48a9                	li	a7,10
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 494:	48ad                	li	a7,11
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49c:	48b1                	li	a7,12
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a4:	48b5                	li	a7,13
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ac:	48b9                	li	a7,14
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4b4:	48f5                	li	a7,29
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 4bc:	48f9                	li	a7,30
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <send>:
.global send
send:
 li a7, SYS_send
 4c4:	48fd                	li	a7,31
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <recv>:
.global recv
recv:
 li a7, SYS_recv
 4cc:	02000893          	li	a7,32
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4d6:	02100893          	li	a7,33
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 4e0:	02200893          	li	a7,34
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4ea:	02400893          	li	a7,36
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f4:	1101                	addi	sp,sp,-32
 4f6:	ec06                	sd	ra,24(sp)
 4f8:	e822                	sd	s0,16(sp)
 4fa:	1000                	addi	s0,sp,32
 4fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 500:	4605                	li	a2,1
 502:	fef40593          	addi	a1,s0,-17
 506:	f2fff0ef          	jal	434 <write>
}
 50a:	60e2                	ld	ra,24(sp)
 50c:	6442                	ld	s0,16(sp)
 50e:	6105                	addi	sp,sp,32
 510:	8082                	ret

0000000000000512 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 512:	7139                	addi	sp,sp,-64
 514:	fc06                	sd	ra,56(sp)
 516:	f822                	sd	s0,48(sp)
 518:	f426                	sd	s1,40(sp)
 51a:	f04a                	sd	s2,32(sp)
 51c:	ec4e                	sd	s3,24(sp)
 51e:	0080                	addi	s0,sp,64
 520:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 522:	c299                	beqz	a3,528 <printint+0x16>
 524:	0605ce63          	bltz	a1,5a0 <printint+0x8e>
  neg = 0;
 528:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 52a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 52e:	869a                	mv	a3,t1
  i = 0;
 530:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 532:	00000817          	auipc	a6,0x0
 536:	51e80813          	addi	a6,a6,1310 # a50 <digits>
 53a:	88be                	mv	a7,a5
 53c:	0017851b          	addiw	a0,a5,1
 540:	87aa                	mv	a5,a0
 542:	02c5f73b          	remuw	a4,a1,a2
 546:	1702                	slli	a4,a4,0x20
 548:	9301                	srli	a4,a4,0x20
 54a:	9742                	add	a4,a4,a6
 54c:	00074703          	lbu	a4,0(a4)
 550:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 554:	872e                	mv	a4,a1
 556:	02c5d5bb          	divuw	a1,a1,a2
 55a:	0685                	addi	a3,a3,1
 55c:	fcc77fe3          	bgeu	a4,a2,53a <printint+0x28>
  if(neg)
 560:	000e0c63          	beqz	t3,578 <printint+0x66>
    buf[i++] = '-';
 564:	fd050793          	addi	a5,a0,-48
 568:	00878533          	add	a0,a5,s0
 56c:	02d00793          	li	a5,45
 570:	fef50823          	sb	a5,-16(a0)
 574:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 578:	fff7899b          	addiw	s3,a5,-1
 57c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 580:	fff4c583          	lbu	a1,-1(s1)
 584:	854a                	mv	a0,s2
 586:	f6fff0ef          	jal	4f4 <putc>
  while(--i >= 0)
 58a:	39fd                	addiw	s3,s3,-1
 58c:	14fd                	addi	s1,s1,-1
 58e:	fe09d9e3          	bgez	s3,580 <printint+0x6e>
}
 592:	70e2                	ld	ra,56(sp)
 594:	7442                	ld	s0,48(sp)
 596:	74a2                	ld	s1,40(sp)
 598:	7902                	ld	s2,32(sp)
 59a:	69e2                	ld	s3,24(sp)
 59c:	6121                	addi	sp,sp,64
 59e:	8082                	ret
    x = -xx;
 5a0:	40b005bb          	negw	a1,a1
    neg = 1;
 5a4:	4e05                	li	t3,1
    x = -xx;
 5a6:	b751                	j	52a <printint+0x18>

00000000000005a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a8:	711d                	addi	sp,sp,-96
 5aa:	ec86                	sd	ra,88(sp)
 5ac:	e8a2                	sd	s0,80(sp)
 5ae:	e4a6                	sd	s1,72(sp)
 5b0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b2:	0005c483          	lbu	s1,0(a1)
 5b6:	26048663          	beqz	s1,822 <vprintf+0x27a>
 5ba:	e0ca                	sd	s2,64(sp)
 5bc:	fc4e                	sd	s3,56(sp)
 5be:	f852                	sd	s4,48(sp)
 5c0:	f456                	sd	s5,40(sp)
 5c2:	f05a                	sd	s6,32(sp)
 5c4:	ec5e                	sd	s7,24(sp)
 5c6:	e862                	sd	s8,16(sp)
 5c8:	e466                	sd	s9,8(sp)
 5ca:	8b2a                	mv	s6,a0
 5cc:	8a2e                	mv	s4,a1
 5ce:	8bb2                	mv	s7,a2
  state = 0;
 5d0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5d2:	4901                	li	s2,0
 5d4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5d6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5de:	06c00c93          	li	s9,108
 5e2:	a00d                	j	604 <vprintf+0x5c>
        putc(fd, c0);
 5e4:	85a6                	mv	a1,s1
 5e6:	855a                	mv	a0,s6
 5e8:	f0dff0ef          	jal	4f4 <putc>
 5ec:	a019                	j	5f2 <vprintf+0x4a>
    } else if(state == '%'){
 5ee:	03598363          	beq	s3,s5,614 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5f2:	0019079b          	addiw	a5,s2,1
 5f6:	893e                	mv	s2,a5
 5f8:	873e                	mv	a4,a5
 5fa:	97d2                	add	a5,a5,s4
 5fc:	0007c483          	lbu	s1,0(a5)
 600:	20048963          	beqz	s1,812 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 604:	0004879b          	sext.w	a5,s1
    if(state == 0){
 608:	fe0993e3          	bnez	s3,5ee <vprintf+0x46>
      if(c0 == '%'){
 60c:	fd579ce3          	bne	a5,s5,5e4 <vprintf+0x3c>
        state = '%';
 610:	89be                	mv	s3,a5
 612:	b7c5                	j	5f2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 614:	00ea06b3          	add	a3,s4,a4
 618:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 61c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 61e:	c681                	beqz	a3,626 <vprintf+0x7e>
 620:	9752                	add	a4,a4,s4
 622:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 626:	03878e63          	beq	a5,s8,662 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 62a:	05978863          	beq	a5,s9,67a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 62e:	07500713          	li	a4,117
 632:	0ee78263          	beq	a5,a4,716 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 636:	07800713          	li	a4,120
 63a:	12e78463          	beq	a5,a4,762 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 63e:	07000713          	li	a4,112
 642:	14e78963          	beq	a5,a4,794 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 646:	07300713          	li	a4,115
 64a:	18e78863          	beq	a5,a4,7da <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 64e:	02500713          	li	a4,37
 652:	04e79463          	bne	a5,a4,69a <vprintf+0xf2>
        putc(fd, '%');
 656:	85ba                	mv	a1,a4
 658:	855a                	mv	a0,s6
 65a:	e9bff0ef          	jal	4f4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 65e:	4981                	li	s3,0
 660:	bf49                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 662:	008b8493          	addi	s1,s7,8
 666:	4685                	li	a3,1
 668:	4629                	li	a2,10
 66a:	000ba583          	lw	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	ea3ff0ef          	jal	512 <printint>
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
 678:	bfad                	j	5f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 67a:	06400793          	li	a5,100
 67e:	02f68963          	beq	a3,a5,6b0 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 682:	06c00793          	li	a5,108
 686:	04f68263          	beq	a3,a5,6ca <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 68a:	07500793          	li	a5,117
 68e:	0af68063          	beq	a3,a5,72e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 692:	07800793          	li	a5,120
 696:	0ef68263          	beq	a3,a5,77a <vprintf+0x1d2>
        putc(fd, '%');
 69a:	02500593          	li	a1,37
 69e:	855a                	mv	a0,s6
 6a0:	e55ff0ef          	jal	4f4 <putc>
        putc(fd, c0);
 6a4:	85a6                	mv	a1,s1
 6a6:	855a                	mv	a0,s6
 6a8:	e4dff0ef          	jal	4f4 <putc>
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b791                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	008b8493          	addi	s1,s7,8
 6b4:	4685                	li	a3,1
 6b6:	4629                	li	a2,10
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	e55ff0ef          	jal	512 <printint>
        i += 1;
 6c2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
        i += 1;
 6c8:	b72d                	j	5f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ca:	06400793          	li	a5,100
 6ce:	02f60763          	beq	a2,a5,6fc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6d2:	07500793          	li	a5,117
 6d6:	06f60963          	beq	a2,a5,748 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6da:	07800793          	li	a5,120
 6de:	faf61ee3          	bne	a2,a5,69a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	e23ff0ef          	jal	512 <printint>
        i += 2;
 6f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
        i += 2;
 6fa:	bde5                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fc:	008b8493          	addi	s1,s7,8
 700:	4685                	li	a3,1
 702:	4629                	li	a2,10
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	e09ff0ef          	jal	512 <printint>
        i += 2;
 70e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 710:	8ba6                	mv	s7,s1
      state = 0;
 712:	4981                	li	s3,0
        i += 2;
 714:	bdf9                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 716:	008b8493          	addi	s1,s7,8
 71a:	4681                	li	a3,0
 71c:	4629                	li	a2,10
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	defff0ef          	jal	512 <printint>
 728:	8ba6                	mv	s7,s1
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b5d9                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	008b8493          	addi	s1,s7,8
 732:	4681                	li	a3,0
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	dd7ff0ef          	jal	512 <printint>
        i += 1;
 740:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	8ba6                	mv	s7,s1
      state = 0;
 744:	4981                	li	s3,0
        i += 1;
 746:	b575                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	008b8493          	addi	s1,s7,8
 74c:	4681                	li	a3,0
 74e:	4629                	li	a2,10
 750:	000ba583          	lw	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	dbdff0ef          	jal	512 <printint>
        i += 2;
 75a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 75c:	8ba6                	mv	s7,s1
      state = 0;
 75e:	4981                	li	s3,0
        i += 2;
 760:	bd49                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 762:	008b8493          	addi	s1,s7,8
 766:	4681                	li	a3,0
 768:	4641                	li	a2,16
 76a:	000ba583          	lw	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	da3ff0ef          	jal	512 <printint>
 774:	8ba6                	mv	s7,s1
      state = 0;
 776:	4981                	li	s3,0
 778:	bdad                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	008b8493          	addi	s1,s7,8
 77e:	4681                	li	a3,0
 780:	4641                	li	a2,16
 782:	000ba583          	lw	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	d8bff0ef          	jal	512 <printint>
        i += 1;
 78c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 78e:	8ba6                	mv	s7,s1
      state = 0;
 790:	4981                	li	s3,0
        i += 1;
 792:	b585                	j	5f2 <vprintf+0x4a>
 794:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 796:	008b8d13          	addi	s10,s7,8
 79a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 79e:	03000593          	li	a1,48
 7a2:	855a                	mv	a0,s6
 7a4:	d51ff0ef          	jal	4f4 <putc>
  putc(fd, 'x');
 7a8:	07800593          	li	a1,120
 7ac:	855a                	mv	a0,s6
 7ae:	d47ff0ef          	jal	4f4 <putc>
 7b2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b4:	00000b97          	auipc	s7,0x0
 7b8:	29cb8b93          	addi	s7,s7,668 # a50 <digits>
 7bc:	03c9d793          	srli	a5,s3,0x3c
 7c0:	97de                	add	a5,a5,s7
 7c2:	0007c583          	lbu	a1,0(a5)
 7c6:	855a                	mv	a0,s6
 7c8:	d2dff0ef          	jal	4f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7cc:	0992                	slli	s3,s3,0x4
 7ce:	34fd                	addiw	s1,s1,-1
 7d0:	f4f5                	bnez	s1,7bc <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7d2:	8bea                	mv	s7,s10
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	6d02                	ld	s10,0(sp)
 7d8:	bd29                	j	5f2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7da:	008b8993          	addi	s3,s7,8
 7de:	000bb483          	ld	s1,0(s7)
 7e2:	cc91                	beqz	s1,7fe <vprintf+0x256>
        for(; *s; s++)
 7e4:	0004c583          	lbu	a1,0(s1)
 7e8:	c195                	beqz	a1,80c <vprintf+0x264>
          putc(fd, *s);
 7ea:	855a                	mv	a0,s6
 7ec:	d09ff0ef          	jal	4f4 <putc>
        for(; *s; s++)
 7f0:	0485                	addi	s1,s1,1
 7f2:	0004c583          	lbu	a1,0(s1)
 7f6:	f9f5                	bnez	a1,7ea <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7f8:	8bce                	mv	s7,s3
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	bbdd                	j	5f2 <vprintf+0x4a>
          s = "(null)";
 7fe:	00000497          	auipc	s1,0x0
 802:	24a48493          	addi	s1,s1,586 # a48 <malloc+0x13a>
        for(; *s; s++)
 806:	02800593          	li	a1,40
 80a:	b7c5                	j	7ea <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 80c:	8bce                	mv	s7,s3
      state = 0;
 80e:	4981                	li	s3,0
 810:	b3cd                	j	5f2 <vprintf+0x4a>
 812:	6906                	ld	s2,64(sp)
 814:	79e2                	ld	s3,56(sp)
 816:	7a42                	ld	s4,48(sp)
 818:	7aa2                	ld	s5,40(sp)
 81a:	7b02                	ld	s6,32(sp)
 81c:	6be2                	ld	s7,24(sp)
 81e:	6c42                	ld	s8,16(sp)
 820:	6ca2                	ld	s9,8(sp)
    }
  }
}
 822:	60e6                	ld	ra,88(sp)
 824:	6446                	ld	s0,80(sp)
 826:	64a6                	ld	s1,72(sp)
 828:	6125                	addi	sp,sp,96
 82a:	8082                	ret

000000000000082c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82c:	715d                	addi	sp,sp,-80
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	addi	s0,sp,32
 834:	e010                	sd	a2,0(s0)
 836:	e414                	sd	a3,8(s0)
 838:	e818                	sd	a4,16(s0)
 83a:	ec1c                	sd	a5,24(s0)
 83c:	03043023          	sd	a6,32(s0)
 840:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 844:	8622                	mv	a2,s0
 846:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84a:	d5fff0ef          	jal	5a8 <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6161                	addi	sp,sp,80
 854:	8082                	ret

0000000000000856 <printf>:

void
printf(const char *fmt, ...)
{
 856:	711d                	addi	sp,sp,-96
 858:	ec06                	sd	ra,24(sp)
 85a:	e822                	sd	s0,16(sp)
 85c:	1000                	addi	s0,sp,32
 85e:	e40c                	sd	a1,8(s0)
 860:	e810                	sd	a2,16(s0)
 862:	ec14                	sd	a3,24(s0)
 864:	f018                	sd	a4,32(s0)
 866:	f41c                	sd	a5,40(s0)
 868:	03043823          	sd	a6,48(s0)
 86c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	00840613          	addi	a2,s0,8
 874:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 878:	85aa                	mv	a1,a0
 87a:	4505                	li	a0,1
 87c:	d2dff0ef          	jal	5a8 <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e406                	sd	ra,8(sp)
 88c:	e022                	sd	s0,0(sp)
 88e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 890:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	00000797          	auipc	a5,0x0
 898:	76c7b783          	ld	a5,1900(a5) # 1000 <freep>
 89c:	a02d                	j	8c6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89e:	4618                	lw	a4,8(a2)
 8a0:	9f2d                	addw	a4,a4,a1
 8a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	6310                	ld	a2,0(a4)
 8aa:	a83d                	j	8e8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ac:	ff852703          	lw	a4,-8(a0)
 8b0:	9f31                	addw	a4,a4,a2
 8b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b4:	ff053683          	ld	a3,-16(a0)
 8b8:	a091                	j	8fc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e7e463          	bltu	a5,a4,8c4 <free+0x3c>
 8c0:	00e6ea63          	bltu	a3,a4,8d4 <free+0x4c>
{
 8c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	fed7fae3          	bgeu	a5,a3,8ba <free+0x32>
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e6e463          	bltu	a3,a4,8d4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	fee7eae3          	bltu	a5,a4,8c4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8d4:	ff852583          	lw	a1,-8(a0)
 8d8:	6390                	ld	a2,0(a5)
 8da:	02059813          	slli	a6,a1,0x20
 8de:	01c85713          	srli	a4,a6,0x1c
 8e2:	9736                	add	a4,a4,a3
 8e4:	fae60de3          	beq	a2,a4,89e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ec:	4790                	lw	a2,8(a5)
 8ee:	02061593          	slli	a1,a2,0x20
 8f2:	01c5d713          	srli	a4,a1,0x1c
 8f6:	973e                	add	a4,a4,a5
 8f8:	fae68ae3          	beq	a3,a4,8ac <free+0x24>
    p->s.ptr = bp->s.ptr;
 8fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8fe:	00000717          	auipc	a4,0x0
 902:	70f73123          	sd	a5,1794(a4) # 1000 <freep>
}
 906:	60a2                	ld	ra,8(sp)
 908:	6402                	ld	s0,0(sp)
 90a:	0141                	addi	sp,sp,16
 90c:	8082                	ret

000000000000090e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 90e:	7139                	addi	sp,sp,-64
 910:	fc06                	sd	ra,56(sp)
 912:	f822                	sd	s0,48(sp)
 914:	f04a                	sd	s2,32(sp)
 916:	ec4e                	sd	s3,24(sp)
 918:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91a:	02051993          	slli	s3,a0,0x20
 91e:	0209d993          	srli	s3,s3,0x20
 922:	09bd                	addi	s3,s3,15
 924:	0049d993          	srli	s3,s3,0x4
 928:	2985                	addiw	s3,s3,1
 92a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 92c:	00000517          	auipc	a0,0x0
 930:	6d453503          	ld	a0,1748(a0) # 1000 <freep>
 934:	c905                	beqz	a0,964 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 938:	4798                	lw	a4,8(a5)
 93a:	09377663          	bgeu	a4,s3,9c6 <malloc+0xb8>
 93e:	f426                	sd	s1,40(sp)
 940:	e852                	sd	s4,16(sp)
 942:	e456                	sd	s5,8(sp)
 944:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 946:	8a4e                	mv	s4,s3
 948:	6705                	lui	a4,0x1
 94a:	00e9f363          	bgeu	s3,a4,950 <malloc+0x42>
 94e:	6a05                	lui	s4,0x1
 950:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 954:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 958:	00000497          	auipc	s1,0x0
 95c:	6a848493          	addi	s1,s1,1704 # 1000 <freep>
  if(p == (char*)-1)
 960:	5afd                	li	s5,-1
 962:	a83d                	j	9a0 <malloc+0x92>
 964:	f426                	sd	s1,40(sp)
 966:	e852                	sd	s4,16(sp)
 968:	e456                	sd	s5,8(sp)
 96a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 96c:	00001797          	auipc	a5,0x1
 970:	8a478793          	addi	a5,a5,-1884 # 1210 <base>
 974:	00000717          	auipc	a4,0x0
 978:	68f73623          	sd	a5,1676(a4) # 1000 <freep>
 97c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 982:	b7d1                	j	946 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	e118                	sd	a4,0(a0)
 988:	a899                	j	9de <malloc+0xd0>
  hp->s.size = nu;
 98a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 98e:	0541                	addi	a0,a0,16
 990:	ef9ff0ef          	jal	888 <free>
  return freep;
 994:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 996:	c125                	beqz	a0,9f6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99a:	4798                	lw	a4,8(a5)
 99c:	03277163          	bgeu	a4,s2,9be <malloc+0xb0>
    if(p == freep)
 9a0:	6098                	ld	a4,0(s1)
 9a2:	853e                	mv	a0,a5
 9a4:	fef71ae3          	bne	a4,a5,998 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9a8:	8552                	mv	a0,s4
 9aa:	af3ff0ef          	jal	49c <sbrk>
  if(p == (char*)-1)
 9ae:	fd551ee3          	bne	a0,s5,98a <malloc+0x7c>
        return 0;
 9b2:	4501                	li	a0,0
 9b4:	74a2                	ld	s1,40(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
 9bc:	a03d                	j	9ea <malloc+0xdc>
 9be:	74a2                	ld	s1,40(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9c6:	fae90fe3          	beq	s2,a4,984 <malloc+0x76>
        p->s.size -= nunits;
 9ca:	4137073b          	subw	a4,a4,s3
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	02071693          	slli	a3,a4,0x20
 9d4:	01c6d713          	srli	a4,a3,0x1c
 9d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62a73123          	sd	a0,1570(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e6:	01078513          	addi	a0,a5,16
  }
}
 9ea:	70e2                	ld	ra,56(sp)
 9ec:	7442                	ld	s0,48(sp)
 9ee:	7902                	ld	s2,32(sp)
 9f0:	69e2                	ld	s3,24(sp)
 9f2:	6121                	addi	sp,sp,64
 9f4:	8082                	ret
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	b7f5                	j	9ea <malloc+0xdc>
