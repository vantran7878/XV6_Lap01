
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2de000ef          	jal	2ea <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2b6000ef          	jal	2ea <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	29a000ef          	jal	2ea <strlen>
  54:	862a                	mv	a2,a0
  56:	00002997          	auipc	s3,0x2
  5a:	fba98993          	addi	s3,s3,-70 # 2010 <buf.0>
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	40e000ef          	jal	470 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  66:	8526                	mv	a0,s1
  68:	282000ef          	jal	2ea <strlen>
  6c:	892a                	mv	s2,a0
  6e:	8526                	mv	a0,s1
  70:	27a000ef          	jal	2ea <strlen>
  74:	1902                	slli	s2,s2,0x20
  76:	02095913          	srli	s2,s2,0x20
  7a:	4639                	li	a2,14
  7c:	9e09                	subw	a2,a2,a0
  7e:	02000593          	li	a1,32
  82:	01298533          	add	a0,s3,s2
  86:	292000ef          	jal	318 <memset>
  return buf;
  8a:	84ce                	mv	s1,s3
  8c:	6942                	ld	s2,16(sp)
  8e:	69a2                	ld	s3,8(sp)
  90:	b77d                	j	3e <fmtname+0x3e>

0000000000000092 <ls>:

void
ls(char *path)
{
  92:	d7010113          	addi	sp,sp,-656
  96:	28113423          	sd	ra,648(sp)
  9a:	28813023          	sd	s0,640(sp)
  9e:	27213823          	sd	s2,624(sp)
  a2:	0d00                	addi	s0,sp,656
  a4:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	4d8000ef          	jal	580 <open>
  ac:	06054363          	bltz	a0,112 <ls+0x80>
  b0:	26913c23          	sd	s1,632(sp)
  b4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b6:	d7840593          	addi	a1,s0,-648
  ba:	4de000ef          	jal	598 <fstat>
  be:	06054363          	bltz	a0,124 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c2:	d8041783          	lh	a5,-640(s0)
  c6:	4705                	li	a4,1
  c8:	06e78c63          	beq	a5,a4,140 <ls+0xae>
  cc:	37f9                	addiw	a5,a5,-2
  ce:	17c2                	slli	a5,a5,0x30
  d0:	93c1                	srli	a5,a5,0x30
  d2:	02f76263          	bltu	a4,a5,f6 <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  d6:	854a                	mv	a0,s2
  d8:	f29ff0ef          	jal	0 <fmtname>
  dc:	85aa                	mv	a1,a0
  de:	d8842703          	lw	a4,-632(s0)
  e2:	d7c42683          	lw	a3,-644(s0)
  e6:	d8041603          	lh	a2,-640(s0)
  ea:	00001517          	auipc	a0,0x1
  ee:	a7650513          	addi	a0,a0,-1418 # b60 <malloc+0x126>
  f2:	091000ef          	jal	982 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  f6:	8526                	mv	a0,s1
  f8:	470000ef          	jal	568 <close>
  fc:	27813483          	ld	s1,632(sp)
}
 100:	28813083          	ld	ra,648(sp)
 104:	28013403          	ld	s0,640(sp)
 108:	27013903          	ld	s2,624(sp)
 10c:	29010113          	addi	sp,sp,656
 110:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 112:	864a                	mv	a2,s2
 114:	00001597          	auipc	a1,0x1
 118:	a1c58593          	addi	a1,a1,-1508 # b30 <malloc+0xf6>
 11c:	4509                	li	a0,2
 11e:	03b000ef          	jal	958 <fprintf>
    return;
 122:	bff9                	j	100 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 124:	864a                	mv	a2,s2
 126:	00001597          	auipc	a1,0x1
 12a:	a2258593          	addi	a1,a1,-1502 # b48 <malloc+0x10e>
 12e:	4509                	li	a0,2
 130:	029000ef          	jal	958 <fprintf>
    close(fd);
 134:	8526                	mv	a0,s1
 136:	432000ef          	jal	568 <close>
    return;
 13a:	27813483          	ld	s1,632(sp)
 13e:	b7c9                	j	100 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 140:	854a                	mv	a0,s2
 142:	1a8000ef          	jal	2ea <strlen>
 146:	2541                	addiw	a0,a0,16
 148:	20000793          	li	a5,512
 14c:	00a7f963          	bgeu	a5,a0,15e <ls+0xcc>
      printf("ls: path too long\n");
 150:	00001517          	auipc	a0,0x1
 154:	a2050513          	addi	a0,a0,-1504 # b70 <malloc+0x136>
 158:	02b000ef          	jal	982 <printf>
      break;
 15c:	bf69                	j	f6 <ls+0x64>
 15e:	27313423          	sd	s3,616(sp)
 162:	27413023          	sd	s4,608(sp)
 166:	25513c23          	sd	s5,600(sp)
 16a:	25613823          	sd	s6,592(sp)
 16e:	25713423          	sd	s7,584(sp)
 172:	25813023          	sd	s8,576(sp)
 176:	23913c23          	sd	s9,568(sp)
 17a:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 17e:	da040993          	addi	s3,s0,-608
 182:	85ca                	mv	a1,s2
 184:	854e                	mv	a0,s3
 186:	114000ef          	jal	29a <strcpy>
    p = buf+strlen(buf);
 18a:	854e                	mv	a0,s3
 18c:	15e000ef          	jal	2ea <strlen>
 190:	1502                	slli	a0,a0,0x20
 192:	9101                	srli	a0,a0,0x20
 194:	99aa                	add	s3,s3,a0
    *p++ = '/';
 196:	00198c93          	addi	s9,s3,1
 19a:	02f00793          	li	a5,47
 19e:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a2:	d9040a13          	addi	s4,s0,-624
 1a6:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1a8:	d9240c13          	addi	s8,s0,-622
 1ac:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1ae:	d7840b13          	addi	s6,s0,-648
 1b2:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1b6:	00001d17          	auipc	s10,0x1
 1ba:	9aad0d13          	addi	s10,s10,-1622 # b60 <malloc+0x126>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1be:	a801                	j	1ce <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c0:	85d6                	mv	a1,s5
 1c2:	00001517          	auipc	a0,0x1
 1c6:	98650513          	addi	a0,a0,-1658 # b48 <malloc+0x10e>
 1ca:	7b8000ef          	jal	982 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ce:	864a                	mv	a2,s2
 1d0:	85d2                	mv	a1,s4
 1d2:	8526                	mv	a0,s1
 1d4:	384000ef          	jal	558 <read>
 1d8:	05251063          	bne	a0,s2,218 <ls+0x186>
      if(de.inum == 0)
 1dc:	d9045783          	lhu	a5,-624(s0)
 1e0:	d7fd                	beqz	a5,1ce <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
 1e2:	865e                	mv	a2,s7
 1e4:	85e2                	mv	a1,s8
 1e6:	8566                	mv	a0,s9
 1e8:	288000ef          	jal	470 <memmove>
      p[DIRSIZ] = 0;
 1ec:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 1f0:	85da                	mv	a1,s6
 1f2:	8556                	mv	a0,s5
 1f4:	1f6000ef          	jal	3ea <stat>
 1f8:	fc0544e3          	bltz	a0,1c0 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fc:	8556                	mv	a0,s5
 1fe:	e03ff0ef          	jal	0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	d8842703          	lw	a4,-632(s0)
 208:	d7c42683          	lw	a3,-644(s0)
 20c:	d8041603          	lh	a2,-640(s0)
 210:	856a                	mv	a0,s10
 212:	770000ef          	jal	982 <printf>
 216:	bf65                	j	1ce <ls+0x13c>
 218:	26813983          	ld	s3,616(sp)
 21c:	26013a03          	ld	s4,608(sp)
 220:	25813a83          	ld	s5,600(sp)
 224:	25013b03          	ld	s6,592(sp)
 228:	24813b83          	ld	s7,584(sp)
 22c:	24013c03          	ld	s8,576(sp)
 230:	23813c83          	ld	s9,568(sp)
 234:	23013d03          	ld	s10,560(sp)
 238:	bd7d                	j	f6 <ls+0x64>

000000000000023a <main>:

int
main(int argc, char *argv[])
{
 23a:	1101                	addi	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 242:	4785                	li	a5,1
 244:	02a7d763          	bge	a5,a0,272 <main+0x38>
 248:	e426                	sd	s1,8(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	00858493          	addi	s1,a1,8
 250:	ffe5091b          	addiw	s2,a0,-2
 254:	02091793          	slli	a5,s2,0x20
 258:	01d7d913          	srli	s2,a5,0x1d
 25c:	05c1                	addi	a1,a1,16
 25e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 260:	6088                	ld	a0,0(s1)
 262:	e31ff0ef          	jal	92 <ls>
  for(i=1; i<argc; i++)
 266:	04a1                	addi	s1,s1,8
 268:	ff249ce3          	bne	s1,s2,260 <main+0x26>
  exit(0);
 26c:	4501                	li	a0,0
 26e:	2d2000ef          	jal	540 <exit>
 272:	e426                	sd	s1,8(sp)
 274:	e04a                	sd	s2,0(sp)
    ls(".");
 276:	00001517          	auipc	a0,0x1
 27a:	91250513          	addi	a0,a0,-1774 # b88 <malloc+0x14e>
 27e:	e15ff0ef          	jal	92 <ls>
    exit(0);
 282:	4501                	li	a0,0
 284:	2bc000ef          	jal	540 <exit>

0000000000000288 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 290:	fabff0ef          	jal	23a <main>
  exit(0);
 294:	4501                	li	a0,0
 296:	2aa000ef          	jal	540 <exit>

000000000000029a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a2:	87aa                	mv	a5,a0
 2a4:	0585                	addi	a1,a1,1
 2a6:	0785                	addi	a5,a5,1
 2a8:	fff5c703          	lbu	a4,-1(a1)
 2ac:	fee78fa3          	sb	a4,-1(a5)
 2b0:	fb75                	bnez	a4,2a4 <strcpy+0xa>
    ;
  return os;
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cb91                	beqz	a5,2da <strcmp+0x20>
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00f71763          	bne	a4,a5,2da <strcmp+0x20>
    p++, q++;
 2d0:	0505                	addi	a0,a0,1
 2d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	fbe5                	bnez	a5,2c8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2da:	0005c503          	lbu	a0,0(a1)
}
 2de:	40a7853b          	subw	a0,a5,a0
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cf99                	beqz	a5,314 <strlen+0x2a>
 2f8:	0505                	addi	a0,a0,1
 2fa:	87aa                	mv	a5,a0
 2fc:	86be                	mv	a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	ff65                	bnez	a4,2fc <strlen+0x12>
 306:	40a6853b          	subw	a0,a3,a0
 30a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfdd                	j	30c <strlen+0x22>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 320:	ca19                	beqz	a2,336 <memset+0x1e>
 322:	87aa                	mv	a5,a0
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 330:	0785                	addi	a5,a5,1
 332:	fee79de3          	bne	a5,a4,32c <memset+0x14>
  }
  return dst;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  for(; *s; s++)
 346:	00054783          	lbu	a5,0(a0)
 34a:	cf81                	beqz	a5,362 <strchr+0x24>
    if(*s == c)
 34c:	00f58763          	beq	a1,a5,35a <strchr+0x1c>
  for(; *s; s++)
 350:	0505                	addi	a0,a0,1
 352:	00054783          	lbu	a5,0(a0)
 356:	fbfd                	bnez	a5,34c <strchr+0xe>
      return (char*)s;
  return 0;
 358:	4501                	li	a0,0
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <strchr+0x1c>

0000000000000366 <gets>:

char*
gets(char *buf, int max)
{
 366:	7159                	addi	sp,sp,-112
 368:	f486                	sd	ra,104(sp)
 36a:	f0a2                	sd	s0,96(sp)
 36c:	eca6                	sd	s1,88(sp)
 36e:	e8ca                	sd	s2,80(sp)
 370:	e4ce                	sd	s3,72(sp)
 372:	e0d2                	sd	s4,64(sp)
 374:	fc56                	sd	s5,56(sp)
 376:	f85a                	sd	s6,48(sp)
 378:	f45e                	sd	s7,40(sp)
 37a:	f062                	sd	s8,32(sp)
 37c:	ec66                	sd	s9,24(sp)
 37e:	e86a                	sd	s10,16(sp)
 380:	1880                	addi	s0,sp,112
 382:	8caa                	mv	s9,a0
 384:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	892a                	mv	s2,a0
 388:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38a:	f9f40b13          	addi	s6,s0,-97
 38e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 390:	4ba9                	li	s7,10
 392:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 394:	8d26                	mv	s10,s1
 396:	0014899b          	addiw	s3,s1,1
 39a:	84ce                	mv	s1,s3
 39c:	0349d563          	bge	s3,s4,3c6 <gets+0x60>
    cc = read(0, &c, 1);
 3a0:	8656                	mv	a2,s5
 3a2:	85da                	mv	a1,s6
 3a4:	4501                	li	a0,0
 3a6:	1b2000ef          	jal	558 <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x60>
    buf[i++] = c;
 3ae:	f9f44783          	lbu	a5,-97(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01778763          	beq	a5,s7,3c4 <gets+0x5e>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd879ce3          	bne	a5,s8,394 <gets+0x2e>
    buf[i++] = c;
 3c0:	8d4e                	mv	s10,s3
 3c2:	a011                	j	3c6 <gets+0x60>
 3c4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c6:	9d66                	add	s10,s10,s9
 3c8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3cc:	8566                	mv	a0,s9
 3ce:	70a6                	ld	ra,104(sp)
 3d0:	7406                	ld	s0,96(sp)
 3d2:	64e6                	ld	s1,88(sp)
 3d4:	6946                	ld	s2,80(sp)
 3d6:	69a6                	ld	s3,72(sp)
 3d8:	6a06                	ld	s4,64(sp)
 3da:	7ae2                	ld	s5,56(sp)
 3dc:	7b42                	ld	s6,48(sp)
 3de:	7ba2                	ld	s7,40(sp)
 3e0:	7c02                	ld	s8,32(sp)
 3e2:	6ce2                	ld	s9,24(sp)
 3e4:	6d42                	ld	s10,16(sp)
 3e6:	6165                	addi	sp,sp,112
 3e8:	8082                	ret

00000000000003ea <stat>:

int
stat(const char *n, struct stat *st)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	e04a                	sd	s2,0(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f6:	4581                	li	a1,0
 3f8:	188000ef          	jal	580 <open>
  if(fd < 0)
 3fc:	02054263          	bltz	a0,420 <stat+0x36>
 400:	e426                	sd	s1,8(sp)
 402:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 404:	85ca                	mv	a1,s2
 406:	192000ef          	jal	598 <fstat>
 40a:	892a                	mv	s2,a0
  close(fd);
 40c:	8526                	mv	a0,s1
 40e:	15a000ef          	jal	568 <close>
  return r;
 412:	64a2                	ld	s1,8(sp)
}
 414:	854a                	mv	a0,s2
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfcd                	j	414 <stat+0x2a>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e406                	sd	ra,8(sp)
 428:	e022                	sd	s0,0(sp)
 42a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42c:	00054683          	lbu	a3,0(a0)
 430:	fd06879b          	addiw	a5,a3,-48
 434:	0ff7f793          	zext.b	a5,a5
 438:	4625                	li	a2,9
 43a:	02f66963          	bltu	a2,a5,46c <atoi+0x48>
 43e:	872a                	mv	a4,a0
  n = 0;
 440:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 442:	0705                	addi	a4,a4,1
 444:	0025179b          	slliw	a5,a0,0x2
 448:	9fa9                	addw	a5,a5,a0
 44a:	0017979b          	slliw	a5,a5,0x1
 44e:	9fb5                	addw	a5,a5,a3
 450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 454:	00074683          	lbu	a3,0(a4)
 458:	fd06879b          	addiw	a5,a3,-48
 45c:	0ff7f793          	zext.b	a5,a5
 460:	fef671e3          	bgeu	a2,a5,442 <atoi+0x1e>
  return n;
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  n = 0;
 46c:	4501                	li	a0,0
 46e:	bfdd                	j	464 <atoi+0x40>

0000000000000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 478:	02b57563          	bgeu	a0,a1,4a2 <memmove+0x32>
    while(n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x2a>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 488:	872a                	mv	a4,a0
      *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49a:	60a2                	ld	ra,8(sp)
 49c:	6402                	ld	s0,0(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
    dst += n;
 4a2:	00c50733          	add	a4,a0,a2
    src += n;
 4a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a8:	fec059e3          	blez	a2,49a <memmove+0x2a>
 4ac:	fff6079b          	addiw	a5,a2,-1
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	fff7c793          	not	a5,a5
 4b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ba:	15fd                	addi	a1,a1,-1
 4bc:	177d                	addi	a4,a4,-1
 4be:	0005c683          	lbu	a3,0(a1)
 4c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c6:	fef71ae3          	bne	a4,a5,4ba <memmove+0x4a>
 4ca:	bfc1                	j	49a <memmove+0x2a>

00000000000004cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d4:	ca0d                	beqz	a2,506 <memcmp+0x3a>
 4d6:	fff6069b          	addiw	a3,a2,-1
 4da:	1682                	slli	a3,a3,0x20
 4dc:	9281                	srli	a3,a3,0x20
 4de:	0685                	addi	a3,a3,1
 4e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	0005c703          	lbu	a4,0(a1)
 4ea:	00e79863          	bne	a5,a4,4fa <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4ee:	0505                	addi	a0,a0,1
    p2++;
 4f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f2:	fed518e3          	bne	a0,a3,4e2 <memcmp+0x16>
  }
  return 0;
 4f6:	4501                	li	a0,0
 4f8:	a019                	j	4fe <memcmp+0x32>
      return *p1 - *p2;
 4fa:	40e7853b          	subw	a0,a5,a4
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret
  return 0;
 506:	4501                	li	a0,0
 508:	bfdd                	j	4fe <memcmp+0x32>

000000000000050a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 512:	f5fff0ef          	jal	470 <memmove>
}
 516:	60a2                	ld	ra,8(sp)
 518:	6402                	ld	s0,0(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e406                	sd	ra,8(sp)
 522:	e022                	sd	s0,0(sp)
 524:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 526:	040007b7          	lui	a5,0x4000
 52a:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdfdd>
 52c:	07b2                	slli	a5,a5,0xc
}
 52e:	4388                	lw	a0,0(a5)
 530:	60a2                	ld	ra,8(sp)
 532:	6402                	ld	s0,0(sp)
 534:	0141                	addi	sp,sp,16
 536:	8082                	ret

0000000000000538 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 538:	4885                	li	a7,1
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <exit>:
.global exit
exit:
 li a7, SYS_exit
 540:	4889                	li	a7,2
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <wait>:
.global wait
wait:
 li a7, SYS_wait
 548:	488d                	li	a7,3
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 550:	4891                	li	a7,4
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <read>:
.global read
read:
 li a7, SYS_read
 558:	4895                	li	a7,5
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <write>:
.global write
write:
 li a7, SYS_write
 560:	48c1                	li	a7,16
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <close>:
.global close
close:
 li a7, SYS_close
 568:	48d5                	li	a7,21
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <kill>:
.global kill
kill:
 li a7, SYS_kill
 570:	4899                	li	a7,6
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <exec>:
.global exec
exec:
 li a7, SYS_exec
 578:	489d                	li	a7,7
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <open>:
.global open
open:
 li a7, SYS_open
 580:	48bd                	li	a7,15
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 588:	48c5                	li	a7,17
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 590:	48c9                	li	a7,18
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 598:	48a1                	li	a7,8
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <link>:
.global link
link:
 li a7, SYS_link
 5a0:	48cd                	li	a7,19
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a8:	48d1                	li	a7,20
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b0:	48a5                	li	a7,9
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b8:	48a9                	li	a7,10
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c0:	48ad                	li	a7,11
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c8:	48b1                	li	a7,12
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d0:	48b5                	li	a7,13
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d8:	48b9                	li	a7,14
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <bind>:
.global bind
bind:
 li a7, SYS_bind
 5e0:	48f5                	li	a7,29
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 5e8:	48f9                	li	a7,30
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <send>:
.global send
send:
 li a7, SYS_send
 5f0:	48fd                	li	a7,31
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <recv>:
.global recv
recv:
 li a7, SYS_recv
 5f8:	02000893          	li	a7,32
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 602:	02100893          	li	a7,33
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 60c:	02200893          	li	a7,34
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 616:	02400893          	li	a7,36
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 620:	1101                	addi	sp,sp,-32
 622:	ec06                	sd	ra,24(sp)
 624:	e822                	sd	s0,16(sp)
 626:	1000                	addi	s0,sp,32
 628:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62c:	4605                	li	a2,1
 62e:	fef40593          	addi	a1,s0,-17
 632:	f2fff0ef          	jal	560 <write>
}
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6105                	addi	sp,sp,32
 63c:	8082                	ret

000000000000063e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63e:	7139                	addi	sp,sp,-64
 640:	fc06                	sd	ra,56(sp)
 642:	f822                	sd	s0,48(sp)
 644:	f426                	sd	s1,40(sp)
 646:	f04a                	sd	s2,32(sp)
 648:	ec4e                	sd	s3,24(sp)
 64a:	0080                	addi	s0,sp,64
 64c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64e:	c299                	beqz	a3,654 <printint+0x16>
 650:	0605ce63          	bltz	a1,6cc <printint+0x8e>
  neg = 0;
 654:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 656:	fc040313          	addi	t1,s0,-64
  neg = 0;
 65a:	869a                	mv	a3,t1
  i = 0;
 65c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 65e:	00000817          	auipc	a6,0x0
 662:	53a80813          	addi	a6,a6,1338 # b98 <digits>
 666:	88be                	mv	a7,a5
 668:	0017851b          	addiw	a0,a5,1
 66c:	87aa                	mv	a5,a0
 66e:	02c5f73b          	remuw	a4,a1,a2
 672:	1702                	slli	a4,a4,0x20
 674:	9301                	srli	a4,a4,0x20
 676:	9742                	add	a4,a4,a6
 678:	00074703          	lbu	a4,0(a4)
 67c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 680:	872e                	mv	a4,a1
 682:	02c5d5bb          	divuw	a1,a1,a2
 686:	0685                	addi	a3,a3,1
 688:	fcc77fe3          	bgeu	a4,a2,666 <printint+0x28>
  if(neg)
 68c:	000e0c63          	beqz	t3,6a4 <printint+0x66>
    buf[i++] = '-';
 690:	fd050793          	addi	a5,a0,-48
 694:	00878533          	add	a0,a5,s0
 698:	02d00793          	li	a5,45
 69c:	fef50823          	sb	a5,-16(a0)
 6a0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6a4:	fff7899b          	addiw	s3,a5,-1
 6a8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6ac:	fff4c583          	lbu	a1,-1(s1)
 6b0:	854a                	mv	a0,s2
 6b2:	f6fff0ef          	jal	620 <putc>
  while(--i >= 0)
 6b6:	39fd                	addiw	s3,s3,-1
 6b8:	14fd                	addi	s1,s1,-1
 6ba:	fe09d9e3          	bgez	s3,6ac <printint+0x6e>
}
 6be:	70e2                	ld	ra,56(sp)
 6c0:	7442                	ld	s0,48(sp)
 6c2:	74a2                	ld	s1,40(sp)
 6c4:	7902                	ld	s2,32(sp)
 6c6:	69e2                	ld	s3,24(sp)
 6c8:	6121                	addi	sp,sp,64
 6ca:	8082                	ret
    x = -xx;
 6cc:	40b005bb          	negw	a1,a1
    neg = 1;
 6d0:	4e05                	li	t3,1
    x = -xx;
 6d2:	b751                	j	656 <printint+0x18>

00000000000006d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d4:	711d                	addi	sp,sp,-96
 6d6:	ec86                	sd	ra,88(sp)
 6d8:	e8a2                	sd	s0,80(sp)
 6da:	e4a6                	sd	s1,72(sp)
 6dc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6de:	0005c483          	lbu	s1,0(a1)
 6e2:	26048663          	beqz	s1,94e <vprintf+0x27a>
 6e6:	e0ca                	sd	s2,64(sp)
 6e8:	fc4e                	sd	s3,56(sp)
 6ea:	f852                	sd	s4,48(sp)
 6ec:	f456                	sd	s5,40(sp)
 6ee:	f05a                	sd	s6,32(sp)
 6f0:	ec5e                	sd	s7,24(sp)
 6f2:	e862                	sd	s8,16(sp)
 6f4:	e466                	sd	s9,8(sp)
 6f6:	8b2a                	mv	s6,a0
 6f8:	8a2e                	mv	s4,a1
 6fa:	8bb2                	mv	s7,a2
  state = 0;
 6fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6fe:	4901                	li	s2,0
 700:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 702:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 706:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 70a:	06c00c93          	li	s9,108
 70e:	a00d                	j	730 <vprintf+0x5c>
        putc(fd, c0);
 710:	85a6                	mv	a1,s1
 712:	855a                	mv	a0,s6
 714:	f0dff0ef          	jal	620 <putc>
 718:	a019                	j	71e <vprintf+0x4a>
    } else if(state == '%'){
 71a:	03598363          	beq	s3,s5,740 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 71e:	0019079b          	addiw	a5,s2,1
 722:	893e                	mv	s2,a5
 724:	873e                	mv	a4,a5
 726:	97d2                	add	a5,a5,s4
 728:	0007c483          	lbu	s1,0(a5)
 72c:	20048963          	beqz	s1,93e <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 730:	0004879b          	sext.w	a5,s1
    if(state == 0){
 734:	fe0993e3          	bnez	s3,71a <vprintf+0x46>
      if(c0 == '%'){
 738:	fd579ce3          	bne	a5,s5,710 <vprintf+0x3c>
        state = '%';
 73c:	89be                	mv	s3,a5
 73e:	b7c5                	j	71e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 740:	00ea06b3          	add	a3,s4,a4
 744:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 748:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 74a:	c681                	beqz	a3,752 <vprintf+0x7e>
 74c:	9752                	add	a4,a4,s4
 74e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 752:	03878e63          	beq	a5,s8,78e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 756:	05978863          	beq	a5,s9,7a6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 75a:	07500713          	li	a4,117
 75e:	0ee78263          	beq	a5,a4,842 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 762:	07800713          	li	a4,120
 766:	12e78463          	beq	a5,a4,88e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 76a:	07000713          	li	a4,112
 76e:	14e78963          	beq	a5,a4,8c0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 772:	07300713          	li	a4,115
 776:	18e78863          	beq	a5,a4,906 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 77a:	02500713          	li	a4,37
 77e:	04e79463          	bne	a5,a4,7c6 <vprintf+0xf2>
        putc(fd, '%');
 782:	85ba                	mv	a1,a4
 784:	855a                	mv	a0,s6
 786:	e9bff0ef          	jal	620 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bf49                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 78e:	008b8493          	addi	s1,s7,8
 792:	4685                	li	a3,1
 794:	4629                	li	a2,10
 796:	000ba583          	lw	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	ea3ff0ef          	jal	63e <printint>
 7a0:	8ba6                	mv	s7,s1
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bfad                	j	71e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7a6:	06400793          	li	a5,100
 7aa:	02f68963          	beq	a3,a5,7dc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ae:	06c00793          	li	a5,108
 7b2:	04f68263          	beq	a3,a5,7f6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 7b6:	07500793          	li	a5,117
 7ba:	0af68063          	beq	a3,a5,85a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 7be:	07800793          	li	a5,120
 7c2:	0ef68263          	beq	a3,a5,8a6 <vprintf+0x1d2>
        putc(fd, '%');
 7c6:	02500593          	li	a1,37
 7ca:	855a                	mv	a0,s6
 7cc:	e55ff0ef          	jal	620 <putc>
        putc(fd, c0);
 7d0:	85a6                	mv	a1,s1
 7d2:	855a                	mv	a0,s6
 7d4:	e4dff0ef          	jal	620 <putc>
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b791                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7dc:	008b8493          	addi	s1,s7,8
 7e0:	4685                	li	a3,1
 7e2:	4629                	li	a2,10
 7e4:	000ba583          	lw	a1,0(s7)
 7e8:	855a                	mv	a0,s6
 7ea:	e55ff0ef          	jal	63e <printint>
        i += 1;
 7ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f0:	8ba6                	mv	s7,s1
      state = 0;
 7f2:	4981                	li	s3,0
        i += 1;
 7f4:	b72d                	j	71e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f6:	06400793          	li	a5,100
 7fa:	02f60763          	beq	a2,a5,828 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7fe:	07500793          	li	a5,117
 802:	06f60963          	beq	a2,a5,874 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 806:	07800793          	li	a5,120
 80a:	faf61ee3          	bne	a2,a5,7c6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 80e:	008b8493          	addi	s1,s7,8
 812:	4681                	li	a3,0
 814:	4641                	li	a2,16
 816:	000ba583          	lw	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	e23ff0ef          	jal	63e <printint>
        i += 2;
 820:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 822:	8ba6                	mv	s7,s1
      state = 0;
 824:	4981                	li	s3,0
        i += 2;
 826:	bde5                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 828:	008b8493          	addi	s1,s7,8
 82c:	4685                	li	a3,1
 82e:	4629                	li	a2,10
 830:	000ba583          	lw	a1,0(s7)
 834:	855a                	mv	a0,s6
 836:	e09ff0ef          	jal	63e <printint>
        i += 2;
 83a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 83c:	8ba6                	mv	s7,s1
      state = 0;
 83e:	4981                	li	s3,0
        i += 2;
 840:	bdf9                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 842:	008b8493          	addi	s1,s7,8
 846:	4681                	li	a3,0
 848:	4629                	li	a2,10
 84a:	000ba583          	lw	a1,0(s7)
 84e:	855a                	mv	a0,s6
 850:	defff0ef          	jal	63e <printint>
 854:	8ba6                	mv	s7,s1
      state = 0;
 856:	4981                	li	s3,0
 858:	b5d9                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 85a:	008b8493          	addi	s1,s7,8
 85e:	4681                	li	a3,0
 860:	4629                	li	a2,10
 862:	000ba583          	lw	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	dd7ff0ef          	jal	63e <printint>
        i += 1;
 86c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 86e:	8ba6                	mv	s7,s1
      state = 0;
 870:	4981                	li	s3,0
        i += 1;
 872:	b575                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 874:	008b8493          	addi	s1,s7,8
 878:	4681                	li	a3,0
 87a:	4629                	li	a2,10
 87c:	000ba583          	lw	a1,0(s7)
 880:	855a                	mv	a0,s6
 882:	dbdff0ef          	jal	63e <printint>
        i += 2;
 886:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 888:	8ba6                	mv	s7,s1
      state = 0;
 88a:	4981                	li	s3,0
        i += 2;
 88c:	bd49                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 88e:	008b8493          	addi	s1,s7,8
 892:	4681                	li	a3,0
 894:	4641                	li	a2,16
 896:	000ba583          	lw	a1,0(s7)
 89a:	855a                	mv	a0,s6
 89c:	da3ff0ef          	jal	63e <printint>
 8a0:	8ba6                	mv	s7,s1
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	bdad                	j	71e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a6:	008b8493          	addi	s1,s7,8
 8aa:	4681                	li	a3,0
 8ac:	4641                	li	a2,16
 8ae:	000ba583          	lw	a1,0(s7)
 8b2:	855a                	mv	a0,s6
 8b4:	d8bff0ef          	jal	63e <printint>
        i += 1;
 8b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8ba:	8ba6                	mv	s7,s1
      state = 0;
 8bc:	4981                	li	s3,0
        i += 1;
 8be:	b585                	j	71e <vprintf+0x4a>
 8c0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8c2:	008b8d13          	addi	s10,s7,8
 8c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ca:	03000593          	li	a1,48
 8ce:	855a                	mv	a0,s6
 8d0:	d51ff0ef          	jal	620 <putc>
  putc(fd, 'x');
 8d4:	07800593          	li	a1,120
 8d8:	855a                	mv	a0,s6
 8da:	d47ff0ef          	jal	620 <putc>
 8de:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e0:	00000b97          	auipc	s7,0x0
 8e4:	2b8b8b93          	addi	s7,s7,696 # b98 <digits>
 8e8:	03c9d793          	srli	a5,s3,0x3c
 8ec:	97de                	add	a5,a5,s7
 8ee:	0007c583          	lbu	a1,0(a5)
 8f2:	855a                	mv	a0,s6
 8f4:	d2dff0ef          	jal	620 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f8:	0992                	slli	s3,s3,0x4
 8fa:	34fd                	addiw	s1,s1,-1
 8fc:	f4f5                	bnez	s1,8e8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8fe:	8bea                	mv	s7,s10
      state = 0;
 900:	4981                	li	s3,0
 902:	6d02                	ld	s10,0(sp)
 904:	bd29                	j	71e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 906:	008b8993          	addi	s3,s7,8
 90a:	000bb483          	ld	s1,0(s7)
 90e:	cc91                	beqz	s1,92a <vprintf+0x256>
        for(; *s; s++)
 910:	0004c583          	lbu	a1,0(s1)
 914:	c195                	beqz	a1,938 <vprintf+0x264>
          putc(fd, *s);
 916:	855a                	mv	a0,s6
 918:	d09ff0ef          	jal	620 <putc>
        for(; *s; s++)
 91c:	0485                	addi	s1,s1,1
 91e:	0004c583          	lbu	a1,0(s1)
 922:	f9f5                	bnez	a1,916 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 924:	8bce                	mv	s7,s3
      state = 0;
 926:	4981                	li	s3,0
 928:	bbdd                	j	71e <vprintf+0x4a>
          s = "(null)";
 92a:	00000497          	auipc	s1,0x0
 92e:	26648493          	addi	s1,s1,614 # b90 <malloc+0x156>
        for(; *s; s++)
 932:	02800593          	li	a1,40
 936:	b7c5                	j	916 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 938:	8bce                	mv	s7,s3
      state = 0;
 93a:	4981                	li	s3,0
 93c:	b3cd                	j	71e <vprintf+0x4a>
 93e:	6906                	ld	s2,64(sp)
 940:	79e2                	ld	s3,56(sp)
 942:	7a42                	ld	s4,48(sp)
 944:	7aa2                	ld	s5,40(sp)
 946:	7b02                	ld	s6,32(sp)
 948:	6be2                	ld	s7,24(sp)
 94a:	6c42                	ld	s8,16(sp)
 94c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 94e:	60e6                	ld	ra,88(sp)
 950:	6446                	ld	s0,80(sp)
 952:	64a6                	ld	s1,72(sp)
 954:	6125                	addi	sp,sp,96
 956:	8082                	ret

0000000000000958 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 958:	715d                	addi	sp,sp,-80
 95a:	ec06                	sd	ra,24(sp)
 95c:	e822                	sd	s0,16(sp)
 95e:	1000                	addi	s0,sp,32
 960:	e010                	sd	a2,0(s0)
 962:	e414                	sd	a3,8(s0)
 964:	e818                	sd	a4,16(s0)
 966:	ec1c                	sd	a5,24(s0)
 968:	03043023          	sd	a6,32(s0)
 96c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 970:	8622                	mv	a2,s0
 972:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 976:	d5fff0ef          	jal	6d4 <vprintf>
}
 97a:	60e2                	ld	ra,24(sp)
 97c:	6442                	ld	s0,16(sp)
 97e:	6161                	addi	sp,sp,80
 980:	8082                	ret

0000000000000982 <printf>:

void
printf(const char *fmt, ...)
{
 982:	711d                	addi	sp,sp,-96
 984:	ec06                	sd	ra,24(sp)
 986:	e822                	sd	s0,16(sp)
 988:	1000                	addi	s0,sp,32
 98a:	e40c                	sd	a1,8(s0)
 98c:	e810                	sd	a2,16(s0)
 98e:	ec14                	sd	a3,24(s0)
 990:	f018                	sd	a4,32(s0)
 992:	f41c                	sd	a5,40(s0)
 994:	03043823          	sd	a6,48(s0)
 998:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 99c:	00840613          	addi	a2,s0,8
 9a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9a4:	85aa                	mv	a1,a0
 9a6:	4505                	li	a0,1
 9a8:	d2dff0ef          	jal	6d4 <vprintf>
}
 9ac:	60e2                	ld	ra,24(sp)
 9ae:	6442                	ld	s0,16(sp)
 9b0:	6125                	addi	sp,sp,96
 9b2:	8082                	ret

00000000000009b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9b4:	1141                	addi	sp,sp,-16
 9b6:	e406                	sd	ra,8(sp)
 9b8:	e022                	sd	s0,0(sp)
 9ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9bc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c0:	00001797          	auipc	a5,0x1
 9c4:	6407b783          	ld	a5,1600(a5) # 2000 <freep>
 9c8:	a02d                	j	9f2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ca:	4618                	lw	a4,8(a2)
 9cc:	9f2d                	addw	a4,a4,a1
 9ce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d2:	6398                	ld	a4,0(a5)
 9d4:	6310                	ld	a2,0(a4)
 9d6:	a83d                	j	a14 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9d8:	ff852703          	lw	a4,-8(a0)
 9dc:	9f31                	addw	a4,a4,a2
 9de:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9e0:	ff053683          	ld	a3,-16(a0)
 9e4:	a091                	j	a28 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e6:	6398                	ld	a4,0(a5)
 9e8:	00e7e463          	bltu	a5,a4,9f0 <free+0x3c>
 9ec:	00e6ea63          	bltu	a3,a4,a00 <free+0x4c>
{
 9f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f2:	fed7fae3          	bgeu	a5,a3,9e6 <free+0x32>
 9f6:	6398                	ld	a4,0(a5)
 9f8:	00e6e463          	bltu	a3,a4,a00 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9fc:	fee7eae3          	bltu	a5,a4,9f0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a00:	ff852583          	lw	a1,-8(a0)
 a04:	6390                	ld	a2,0(a5)
 a06:	02059813          	slli	a6,a1,0x20
 a0a:	01c85713          	srli	a4,a6,0x1c
 a0e:	9736                	add	a4,a4,a3
 a10:	fae60de3          	beq	a2,a4,9ca <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a14:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a18:	4790                	lw	a2,8(a5)
 a1a:	02061593          	slli	a1,a2,0x20
 a1e:	01c5d713          	srli	a4,a1,0x1c
 a22:	973e                	add	a4,a4,a5
 a24:	fae68ae3          	beq	a3,a4,9d8 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a28:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a2a:	00001717          	auipc	a4,0x1
 a2e:	5cf73b23          	sd	a5,1494(a4) # 2000 <freep>
}
 a32:	60a2                	ld	ra,8(sp)
 a34:	6402                	ld	s0,0(sp)
 a36:	0141                	addi	sp,sp,16
 a38:	8082                	ret

0000000000000a3a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a3a:	7139                	addi	sp,sp,-64
 a3c:	fc06                	sd	ra,56(sp)
 a3e:	f822                	sd	s0,48(sp)
 a40:	f04a                	sd	s2,32(sp)
 a42:	ec4e                	sd	s3,24(sp)
 a44:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a46:	02051993          	slli	s3,a0,0x20
 a4a:	0209d993          	srli	s3,s3,0x20
 a4e:	09bd                	addi	s3,s3,15
 a50:	0049d993          	srli	s3,s3,0x4
 a54:	2985                	addiw	s3,s3,1
 a56:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a58:	00001517          	auipc	a0,0x1
 a5c:	5a853503          	ld	a0,1448(a0) # 2000 <freep>
 a60:	c905                	beqz	a0,a90 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a62:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a64:	4798                	lw	a4,8(a5)
 a66:	09377663          	bgeu	a4,s3,af2 <malloc+0xb8>
 a6a:	f426                	sd	s1,40(sp)
 a6c:	e852                	sd	s4,16(sp)
 a6e:	e456                	sd	s5,8(sp)
 a70:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a72:	8a4e                	mv	s4,s3
 a74:	6705                	lui	a4,0x1
 a76:	00e9f363          	bgeu	s3,a4,a7c <malloc+0x42>
 a7a:	6a05                	lui	s4,0x1
 a7c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a80:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a84:	00001497          	auipc	s1,0x1
 a88:	57c48493          	addi	s1,s1,1404 # 2000 <freep>
  if(p == (char*)-1)
 a8c:	5afd                	li	s5,-1
 a8e:	a83d                	j	acc <malloc+0x92>
 a90:	f426                	sd	s1,40(sp)
 a92:	e852                	sd	s4,16(sp)
 a94:	e456                	sd	s5,8(sp)
 a96:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a98:	00001797          	auipc	a5,0x1
 a9c:	58878793          	addi	a5,a5,1416 # 2020 <base>
 aa0:	00001717          	auipc	a4,0x1
 aa4:	56f73023          	sd	a5,1376(a4) # 2000 <freep>
 aa8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aaa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aae:	b7d1                	j	a72 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 ab0:	6398                	ld	a4,0(a5)
 ab2:	e118                	sd	a4,0(a0)
 ab4:	a899                	j	b0a <malloc+0xd0>
  hp->s.size = nu;
 ab6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aba:	0541                	addi	a0,a0,16
 abc:	ef9ff0ef          	jal	9b4 <free>
  return freep;
 ac0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 ac2:	c125                	beqz	a0,b22 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ac6:	4798                	lw	a4,8(a5)
 ac8:	03277163          	bgeu	a4,s2,aea <malloc+0xb0>
    if(p == freep)
 acc:	6098                	ld	a4,0(s1)
 ace:	853e                	mv	a0,a5
 ad0:	fef71ae3          	bne	a4,a5,ac4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ad4:	8552                	mv	a0,s4
 ad6:	af3ff0ef          	jal	5c8 <sbrk>
  if(p == (char*)-1)
 ada:	fd551ee3          	bne	a0,s5,ab6 <malloc+0x7c>
        return 0;
 ade:	4501                	li	a0,0
 ae0:	74a2                	ld	s1,40(sp)
 ae2:	6a42                	ld	s4,16(sp)
 ae4:	6aa2                	ld	s5,8(sp)
 ae6:	6b02                	ld	s6,0(sp)
 ae8:	a03d                	j	b16 <malloc+0xdc>
 aea:	74a2                	ld	s1,40(sp)
 aec:	6a42                	ld	s4,16(sp)
 aee:	6aa2                	ld	s5,8(sp)
 af0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 af2:	fae90fe3          	beq	s2,a4,ab0 <malloc+0x76>
        p->s.size -= nunits;
 af6:	4137073b          	subw	a4,a4,s3
 afa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 afc:	02071693          	slli	a3,a4,0x20
 b00:	01c6d713          	srli	a4,a3,0x1c
 b04:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b06:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b0a:	00001717          	auipc	a4,0x1
 b0e:	4ea73b23          	sd	a0,1270(a4) # 2000 <freep>
      return (void*)(p + 1);
 b12:	01078513          	addi	a0,a5,16
  }
}
 b16:	70e2                	ld	ra,56(sp)
 b18:	7442                	ld	s0,48(sp)
 b1a:	7902                	ld	s2,32(sp)
 b1c:	69e2                	ld	s3,24(sp)
 b1e:	6121                	addi	sp,sp,64
 b20:	8082                	ret
 b22:	74a2                	ld	s1,40(sp)
 b24:	6a42                	ld	s4,16(sp)
 b26:	6aa2                	ld	s5,8(sp)
 b28:	6b02                	ld	s6,0(sp)
 b2a:	b7f5                	j	b16 <malloc+0xdc>
