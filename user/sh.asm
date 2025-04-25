
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	24e58593          	addi	a1,a1,590 # 1260 <malloc+0x100>
      1a:	8532                	mv	a0,a2
      1c:	46b000ef          	jal	c86 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	219000ef          	jal	a3e <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	25f000ef          	jal	a8c <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	21c58593          	addi	a1,a1,540 # 1270 <malloc+0x110>
      5c:	4509                	li	a0,2
      5e:	020010ef          	jal	107e <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	403000ef          	jal	c66 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	3ef000ef          	jal	c5e <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	1f650513          	addi	a0,a0,502 # 1278 <malloc+0x118>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	2ce70713          	addi	a4,a4,718 # 1378 <malloc+0x218>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	3a9000ef          	jal	c66 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	1be50513          	addi	a0,a0,446 # 1280 <malloc+0x120>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	3c9000ef          	jal	c9e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	1ac58593          	addi	a1,a1,428 # 1288 <malloc+0x128>
      e4:	4509                	li	a0,2
      e6:	799000ef          	jal	107e <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	37b000ef          	jal	c66 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	375000ef          	jal	c66 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	397000ef          	jal	c8e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	3a7000ef          	jal	ca6 <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	18858593          	addi	a1,a1,392 # 1298 <malloc+0x138>
     118:	4509                	li	a0,2
     11a:	765000ef          	jal	107e <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	347000ef          	jal	c66 <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	33d000ef          	jal	c6e <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	337000ef          	jal	c76 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	33f000ef          	jal	c8e <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	387000ef          	jal	cde <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	32f000ef          	jal	c8e <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	327000ef          	jal	c8e <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	13650513          	addi	a0,a0,310 # 12a8 <malloc+0x148>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	30b000ef          	jal	c8e <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	353000ef          	jal	cde <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	2fb000ef          	jal	c8e <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	2f3000ef          	jal	c8e <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	2e5000ef          	jal	c8e <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	2dd000ef          	jal	c8e <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	2b7000ef          	jal	c6e <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	2b1000ef          	jal	c6e <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	781000ef          	jal	1160 <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	053000ef          	jal	a3e <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	8b2a                	mv	s6,a0
     216:	8aae                	mv	s5,a1
     218:	8a32                	mv	s4,a2
     21a:	89b6                	mv	s3,a3
     21c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	73f000ef          	jal	1160 <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	011000ef          	jal	a3e <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     23a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     246:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	89aa                	mv	s3,a0
     270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	6ed000ef          	jal	1160 <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7c0000ef          	jal	a3e <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     28a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	89aa                	mv	s3,a0
     2ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	6af000ef          	jal	1160 <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	782000ef          	jal	a3e <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	675000ef          	jal	1160 <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	748000ef          	jal	a3e <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	724000ef          	jal	a64 <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76b63          	bltu	a4,a5,3f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6c2000ef          	jal	a64 <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	02e79163          	bne	a5,a4,3f0 <gettoken+0xe0>
    s++;
     3d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d6:	0014c703          	lbu	a4,1(s1)
     3da:	03e00793          	li	a5,62
      s++;
     3de:	0489                	addi	s1,s1,2
      ret = '+';
     3e0:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e4:	faf702e3          	beq	a4,a5,388 <gettoken+0x78>
    s++;
     3e8:	84b6                	mv	s1,a3
  ret = *s;
     3ea:	03e00a93          	li	s5,62
     3ee:	bf69                	j	388 <gettoken+0x78>
  switch(*s){
     3f0:	07c00713          	li	a4,124
     3f4:	f8e789e3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f8:	00002997          	auipc	s3,0x2
     3fc:	c1098993          	addi	s3,s3,-1008 # 2008 <whitespace>
     400:	00002a97          	auipc	s5,0x2
     404:	c00a8a93          	addi	s5,s5,-1024 # 2000 <symbols>
     408:	0324fd63          	bgeu	s1,s2,442 <gettoken+0x132>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	854e                	mv	a0,s3
     412:	652000ef          	jal	a64 <strchr>
     416:	e11d                	bnez	a0,43c <gettoken+0x12c>
     418:	0004c583          	lbu	a1,0(s1)
     41c:	8556                	mv	a0,s5
     41e:	646000ef          	jal	a64 <strchr>
     422:	e911                	bnez	a0,436 <gettoken+0x126>
      s++;
     424:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     426:	fe9913e3          	bne	s2,s1,40c <gettoken+0xfc>
  if(eq)
     42a:	84ca                	mv	s1,s2
    ret = 'a';
     42c:	06100a93          	li	s5,97
  if(eq)
     430:	f40b1ee3          	bnez	s6,38c <gettoken+0x7c>
     434:	bfb5                	j	3b0 <gettoken+0xa0>
    ret = 'a';
     436:	06100a93          	li	s5,97
     43a:	b7b9                	j	388 <gettoken+0x78>
     43c:	06100a93          	li	s5,97
     440:	b7a1                	j	388 <gettoken+0x78>
     442:	06100a93          	li	s5,97
  if(eq)
     446:	f40b13e3          	bnez	s6,38c <gettoken+0x7c>
     44a:	b79d                	j	3b0 <gettoken+0xa0>

000000000000044c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44c:	7139                	addi	sp,sp,-64
     44e:	fc06                	sd	ra,56(sp)
     450:	f822                	sd	s0,48(sp)
     452:	f426                	sd	s1,40(sp)
     454:	f04a                	sd	s2,32(sp)
     456:	ec4e                	sd	s3,24(sp)
     458:	e852                	sd	s4,16(sp)
     45a:	e456                	sd	s5,8(sp)
     45c:	0080                	addi	s0,sp,64
     45e:	8a2a                	mv	s4,a0
     460:	892e                	mv	s2,a1
     462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     466:	00002997          	auipc	s3,0x2
     46a:	ba298993          	addi	s3,s3,-1118 # 2008 <whitespace>
     46e:	00b4fc63          	bgeu	s1,a1,486 <peek+0x3a>
     472:	0004c583          	lbu	a1,0(s1)
     476:	854e                	mv	a0,s3
     478:	5ec000ef          	jal	a64 <strchr>
     47c:	c509                	beqz	a0,486 <peek+0x3a>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9919e3          	bne	s2,s1,472 <peek+0x26>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     48a:	0004c583          	lbu	a1,0(s1)
     48e:	4501                	li	a0,0
     490:	e991                	bnez	a1,4a4 <peek+0x58>
}
     492:	70e2                	ld	ra,56(sp)
     494:	7442                	ld	s0,48(sp)
     496:	74a2                	ld	s1,40(sp)
     498:	7902                	ld	s2,32(sp)
     49a:	69e2                	ld	s3,24(sp)
     49c:	6a42                	ld	s4,16(sp)
     49e:	6aa2                	ld	s5,8(sp)
     4a0:	6121                	addi	sp,sp,64
     4a2:	8082                	ret
  return *s && strchr(toks, *s);
     4a4:	8556                	mv	a0,s5
     4a6:	5be000ef          	jal	a64 <strchr>
     4aa:	00a03533          	snez	a0,a0
     4ae:	b7d5                	j	492 <peek+0x46>

00000000000004b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4b0:	7159                	addi	sp,sp,-112
     4b2:	f486                	sd	ra,104(sp)
     4b4:	f0a2                	sd	s0,96(sp)
     4b6:	eca6                	sd	s1,88(sp)
     4b8:	e8ca                	sd	s2,80(sp)
     4ba:	e4ce                	sd	s3,72(sp)
     4bc:	e0d2                	sd	s4,64(sp)
     4be:	fc56                	sd	s5,56(sp)
     4c0:	f85a                	sd	s6,48(sp)
     4c2:	f45e                	sd	s7,40(sp)
     4c4:	f062                	sd	s8,32(sp)
     4c6:	ec66                	sd	s9,24(sp)
     4c8:	1880                	addi	s0,sp,112
     4ca:	8a2a                	mv	s4,a0
     4cc:	89ae                	mv	s3,a1
     4ce:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4d0:	00001b17          	auipc	s6,0x1
     4d4:	e00b0b13          	addi	s6,s6,-512 # 12d0 <malloc+0x170>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d8:	f9040c93          	addi	s9,s0,-112
     4dc:	f9840c13          	addi	s8,s0,-104
     4e0:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     4e4:	a00d                	j	506 <parseredirs+0x56>
      panic("missing file for redirection");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	dca50513          	addi	a0,a0,-566 # 12b0 <malloc+0x150>
     4ee:	b5dff0ef          	jal	4a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4f2:	4701                	li	a4,0
     4f4:	4681                	li	a3,0
     4f6:	f9043603          	ld	a2,-112(s0)
     4fa:	f9843583          	ld	a1,-104(s0)
     4fe:	8552                	mv	a0,s4
     500:	d01ff0ef          	jal	200 <redircmd>
     504:	8a2a                	mv	s4,a0
    switch(tok){
     506:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     50a:	865a                	mv	a2,s6
     50c:	85ca                	mv	a1,s2
     50e:	854e                	mv	a0,s3
     510:	f3dff0ef          	jal	44c <peek>
     514:	c135                	beqz	a0,578 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     516:	4681                	li	a3,0
     518:	4601                	li	a2,0
     51a:	85ca                	mv	a1,s2
     51c:	854e                	mv	a0,s3
     51e:	df3ff0ef          	jal	310 <gettoken>
     522:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     524:	86e6                	mv	a3,s9
     526:	8662                	mv	a2,s8
     528:	85ca                	mv	a1,s2
     52a:	854e                	mv	a0,s3
     52c:	de5ff0ef          	jal	310 <gettoken>
     530:	fb751be3          	bne	a0,s7,4e6 <parseredirs+0x36>
    switch(tok){
     534:	fb548fe3          	beq	s1,s5,4f2 <parseredirs+0x42>
     538:	03e00793          	li	a5,62
     53c:	02f48263          	beq	s1,a5,560 <parseredirs+0xb0>
     540:	02b00793          	li	a5,43
     544:	fcf493e3          	bne	s1,a5,50a <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     548:	4705                	li	a4,1
     54a:	20100693          	li	a3,513
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca9ff0ef          	jal	200 <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	b765                	j	506 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     560:	4705                	li	a4,1
     562:	60100693          	li	a3,1537
     566:	f9043603          	ld	a2,-112(s0)
     56a:	f9843583          	ld	a1,-104(s0)
     56e:	8552                	mv	a0,s4
     570:	c91ff0ef          	jal	200 <redircmd>
     574:	8a2a                	mv	s4,a0
      break;
     576:	bf41                	j	506 <parseredirs+0x56>
    }
  }
  return cmd;
}
     578:	8552                	mv	a0,s4
     57a:	70a6                	ld	ra,104(sp)
     57c:	7406                	ld	s0,96(sp)
     57e:	64e6                	ld	s1,88(sp)
     580:	6946                	ld	s2,80(sp)
     582:	69a6                	ld	s3,72(sp)
     584:	6a06                	ld	s4,64(sp)
     586:	7ae2                	ld	s5,56(sp)
     588:	7b42                	ld	s6,48(sp)
     58a:	7ba2                	ld	s7,40(sp)
     58c:	7c02                	ld	s8,32(sp)
     58e:	6ce2                	ld	s9,24(sp)
     590:	6165                	addi	sp,sp,112
     592:	8082                	ret

0000000000000594 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     594:	7119                	addi	sp,sp,-128
     596:	fc86                	sd	ra,120(sp)
     598:	f8a2                	sd	s0,112(sp)
     59a:	f4a6                	sd	s1,104(sp)
     59c:	e8d2                	sd	s4,80(sp)
     59e:	e4d6                	sd	s5,72(sp)
     5a0:	0100                	addi	s0,sp,128
     5a2:	8a2a                	mv	s4,a0
     5a4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a6:	00001617          	auipc	a2,0x1
     5aa:	d3260613          	addi	a2,a2,-718 # 12d8 <malloc+0x178>
     5ae:	e9fff0ef          	jal	44c <peek>
     5b2:	e121                	bnez	a0,5f2 <parseexec+0x5e>
     5b4:	f0ca                	sd	s2,96(sp)
     5b6:	ecce                	sd	s3,88(sp)
     5b8:	e0da                	sd	s6,64(sp)
     5ba:	fc5e                	sd	s7,56(sp)
     5bc:	f862                	sd	s8,48(sp)
     5be:	f466                	sd	s9,40(sp)
     5c0:	f06a                	sd	s10,32(sp)
     5c2:	ec6e                	sd	s11,24(sp)
     5c4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c6:	c0dff0ef          	jal	1d2 <execcmd>
     5ca:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5cc:	8656                	mv	a2,s5
     5ce:	85d2                	mv	a1,s4
     5d0:	ee1ff0ef          	jal	4b0 <parseredirs>
     5d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5d6:	008d8913          	addi	s2,s11,8
     5da:	00001b17          	auipc	s6,0x1
     5de:	d1eb0b13          	addi	s6,s6,-738 # 12f8 <malloc+0x198>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5e2:	f8040c13          	addi	s8,s0,-128
     5e6:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     5ea:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ee:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     5f0:	a815                	j	624 <parseexec+0x90>
    return parseblock(ps, es);
     5f2:	85d6                	mv	a1,s5
     5f4:	8552                	mv	a0,s4
     5f6:	170000ef          	jal	766 <parseblock>
     5fa:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5fc:	8526                	mv	a0,s1
     5fe:	70e6                	ld	ra,120(sp)
     600:	7446                	ld	s0,112(sp)
     602:	74a6                	ld	s1,104(sp)
     604:	6a46                	ld	s4,80(sp)
     606:	6aa6                	ld	s5,72(sp)
     608:	6109                	addi	sp,sp,128
     60a:	8082                	ret
      panic("syntax");
     60c:	00001517          	auipc	a0,0x1
     610:	cd450513          	addi	a0,a0,-812 # 12e0 <malloc+0x180>
     614:	a37ff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     618:	8656                	mv	a2,s5
     61a:	85d2                	mv	a1,s4
     61c:	8526                	mv	a0,s1
     61e:	e93ff0ef          	jal	4b0 <parseredirs>
     622:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     624:	865a                	mv	a2,s6
     626:	85d6                	mv	a1,s5
     628:	8552                	mv	a0,s4
     62a:	e23ff0ef          	jal	44c <peek>
     62e:	ed05                	bnez	a0,666 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     630:	86e2                	mv	a3,s8
     632:	865e                	mv	a2,s7
     634:	85d6                	mv	a1,s5
     636:	8552                	mv	a0,s4
     638:	cd9ff0ef          	jal	310 <gettoken>
     63c:	c50d                	beqz	a0,666 <parseexec+0xd2>
    if(tok != 'a')
     63e:	fda517e3          	bne	a0,s10,60c <parseexec+0x78>
    cmd->argv[argc] = q;
     642:	f8843783          	ld	a5,-120(s0)
     646:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     64a:	f8043783          	ld	a5,-128(s0)
     64e:	04f93823          	sd	a5,80(s2)
    argc++;
     652:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     654:	0921                	addi	s2,s2,8
     656:	fd9991e3          	bne	s3,s9,618 <parseexec+0x84>
      panic("too many args");
     65a:	00001517          	auipc	a0,0x1
     65e:	c8e50513          	addi	a0,a0,-882 # 12e8 <malloc+0x188>
     662:	9e9ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     666:	098e                	slli	s3,s3,0x3
     668:	9dce                	add	s11,s11,s3
     66a:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
     66e:	040dbc23          	sd	zero,88(s11)
     672:	7906                	ld	s2,96(sp)
     674:	69e6                	ld	s3,88(sp)
     676:	6b06                	ld	s6,64(sp)
     678:	7be2                	ld	s7,56(sp)
     67a:	7c42                	ld	s8,48(sp)
     67c:	7ca2                	ld	s9,40(sp)
     67e:	7d02                	ld	s10,32(sp)
     680:	6de2                	ld	s11,24(sp)
  return ret;
     682:	bfad                	j	5fc <parseexec+0x68>

0000000000000684 <parsepipe>:
{
     684:	7179                	addi	sp,sp,-48
     686:	f406                	sd	ra,40(sp)
     688:	f022                	sd	s0,32(sp)
     68a:	ec26                	sd	s1,24(sp)
     68c:	e84a                	sd	s2,16(sp)
     68e:	e44e                	sd	s3,8(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     696:	effff0ef          	jal	594 <parseexec>
     69a:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     69c:	00001617          	auipc	a2,0x1
     6a0:	c6460613          	addi	a2,a2,-924 # 1300 <malloc+0x1a0>
     6a4:	85ce                	mv	a1,s3
     6a6:	854a                	mv	a0,s2
     6a8:	da5ff0ef          	jal	44c <peek>
     6ac:	e909                	bnez	a0,6be <parsepipe+0x3a>
}
     6ae:	8526                	mv	a0,s1
     6b0:	70a2                	ld	ra,40(sp)
     6b2:	7402                	ld	s0,32(sp)
     6b4:	64e2                	ld	s1,24(sp)
     6b6:	6942                	ld	s2,16(sp)
     6b8:	69a2                	ld	s3,8(sp)
     6ba:	6145                	addi	sp,sp,48
     6bc:	8082                	ret
    gettoken(ps, es, 0, 0);
     6be:	4681                	li	a3,0
     6c0:	4601                	li	a2,0
     6c2:	85ce                	mv	a1,s3
     6c4:	854a                	mv	a0,s2
     6c6:	c4bff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	85ce                	mv	a1,s3
     6cc:	854a                	mv	a0,s2
     6ce:	fb7ff0ef          	jal	684 <parsepipe>
     6d2:	85aa                	mv	a1,a0
     6d4:	8526                	mv	a0,s1
     6d6:	b8bff0ef          	jal	260 <pipecmd>
     6da:	84aa                	mv	s1,a0
  return cmd;
     6dc:	bfc9                	j	6ae <parsepipe+0x2a>

00000000000006de <parseline>:
{
     6de:	7179                	addi	sp,sp,-48
     6e0:	f406                	sd	ra,40(sp)
     6e2:	f022                	sd	s0,32(sp)
     6e4:	ec26                	sd	s1,24(sp)
     6e6:	e84a                	sd	s2,16(sp)
     6e8:	e44e                	sd	s3,8(sp)
     6ea:	e052                	sd	s4,0(sp)
     6ec:	1800                	addi	s0,sp,48
     6ee:	892a                	mv	s2,a0
     6f0:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f2:	f93ff0ef          	jal	684 <parsepipe>
     6f6:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6f8:	00001a17          	auipc	s4,0x1
     6fc:	c10a0a13          	addi	s4,s4,-1008 # 1308 <malloc+0x1a8>
     700:	a819                	j	716 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     702:	4681                	li	a3,0
     704:	4601                	li	a2,0
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	c07ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     70e:	8526                	mv	a0,s1
     710:	bcdff0ef          	jal	2dc <backcmd>
     714:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     716:	8652                	mv	a2,s4
     718:	85ce                	mv	a1,s3
     71a:	854a                	mv	a0,s2
     71c:	d31ff0ef          	jal	44c <peek>
     720:	f16d                	bnez	a0,702 <parseline+0x24>
  if(peek(ps, es, ";")){
     722:	00001617          	auipc	a2,0x1
     726:	bee60613          	addi	a2,a2,-1042 # 1310 <malloc+0x1b0>
     72a:	85ce                	mv	a1,s3
     72c:	854a                	mv	a0,s2
     72e:	d1fff0ef          	jal	44c <peek>
     732:	e911                	bnez	a0,746 <parseline+0x68>
}
     734:	8526                	mv	a0,s1
     736:	70a2                	ld	ra,40(sp)
     738:	7402                	ld	s0,32(sp)
     73a:	64e2                	ld	s1,24(sp)
     73c:	6942                	ld	s2,16(sp)
     73e:	69a2                	ld	s3,8(sp)
     740:	6a02                	ld	s4,0(sp)
     742:	6145                	addi	sp,sp,48
     744:	8082                	ret
    gettoken(ps, es, 0, 0);
     746:	4681                	li	a3,0
     748:	4601                	li	a2,0
     74a:	85ce                	mv	a1,s3
     74c:	854a                	mv	a0,s2
     74e:	bc3ff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     752:	85ce                	mv	a1,s3
     754:	854a                	mv	a0,s2
     756:	f89ff0ef          	jal	6de <parseline>
     75a:	85aa                	mv	a1,a0
     75c:	8526                	mv	a0,s1
     75e:	b41ff0ef          	jal	29e <listcmd>
     762:	84aa                	mv	s1,a0
  return cmd;
     764:	bfc1                	j	734 <parseline+0x56>

0000000000000766 <parseblock>:
{
     766:	7179                	addi	sp,sp,-48
     768:	f406                	sd	ra,40(sp)
     76a:	f022                	sd	s0,32(sp)
     76c:	ec26                	sd	s1,24(sp)
     76e:	e84a                	sd	s2,16(sp)
     770:	e44e                	sd	s3,8(sp)
     772:	1800                	addi	s0,sp,48
     774:	84aa                	mv	s1,a0
     776:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     778:	00001617          	auipc	a2,0x1
     77c:	b6060613          	addi	a2,a2,-1184 # 12d8 <malloc+0x178>
     780:	ccdff0ef          	jal	44c <peek>
     784:	c539                	beqz	a0,7d2 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     786:	4681                	li	a3,0
     788:	4601                	li	a2,0
     78a:	85ca                	mv	a1,s2
     78c:	8526                	mv	a0,s1
     78e:	b83ff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     792:	85ca                	mv	a1,s2
     794:	8526                	mv	a0,s1
     796:	f49ff0ef          	jal	6de <parseline>
     79a:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     79c:	00001617          	auipc	a2,0x1
     7a0:	b8c60613          	addi	a2,a2,-1140 # 1328 <malloc+0x1c8>
     7a4:	85ca                	mv	a1,s2
     7a6:	8526                	mv	a0,s1
     7a8:	ca5ff0ef          	jal	44c <peek>
     7ac:	c90d                	beqz	a0,7de <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7ae:	4681                	li	a3,0
     7b0:	4601                	li	a2,0
     7b2:	85ca                	mv	a1,s2
     7b4:	8526                	mv	a0,s1
     7b6:	b5bff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7ba:	864a                	mv	a2,s2
     7bc:	85a6                	mv	a1,s1
     7be:	854e                	mv	a0,s3
     7c0:	cf1ff0ef          	jal	4b0 <parseredirs>
}
     7c4:	70a2                	ld	ra,40(sp)
     7c6:	7402                	ld	s0,32(sp)
     7c8:	64e2                	ld	s1,24(sp)
     7ca:	6942                	ld	s2,16(sp)
     7cc:	69a2                	ld	s3,8(sp)
     7ce:	6145                	addi	sp,sp,48
     7d0:	8082                	ret
    panic("parseblock");
     7d2:	00001517          	auipc	a0,0x1
     7d6:	b4650513          	addi	a0,a0,-1210 # 1318 <malloc+0x1b8>
     7da:	871ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7de:	00001517          	auipc	a0,0x1
     7e2:	b5250513          	addi	a0,a0,-1198 # 1330 <malloc+0x1d0>
     7e6:	865ff0ef          	jal	4a <panic>

00000000000007ea <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ea:	1101                	addi	sp,sp,-32
     7ec:	ec06                	sd	ra,24(sp)
     7ee:	e822                	sd	s0,16(sp)
     7f0:	e426                	sd	s1,8(sp)
     7f2:	1000                	addi	s0,sp,32
     7f4:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7f6:	c131                	beqz	a0,83a <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7f8:	4118                	lw	a4,0(a0)
     7fa:	4795                	li	a5,5
     7fc:	02e7ef63          	bltu	a5,a4,83a <nulterminate+0x50>
     800:	00056783          	lwu	a5,0(a0)
     804:	078a                	slli	a5,a5,0x2
     806:	00001717          	auipc	a4,0x1
     80a:	b8a70713          	addi	a4,a4,-1142 # 1390 <malloc+0x230>
     80e:	97ba                	add	a5,a5,a4
     810:	439c                	lw	a5,0(a5)
     812:	97ba                	add	a5,a5,a4
     814:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     816:	651c                	ld	a5,8(a0)
     818:	c38d                	beqz	a5,83a <nulterminate+0x50>
     81a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     81e:	67b8                	ld	a4,72(a5)
     820:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     824:	07a1                	addi	a5,a5,8
     826:	ff87b703          	ld	a4,-8(a5)
     82a:	fb75                	bnez	a4,81e <nulterminate+0x34>
     82c:	a039                	j	83a <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     82e:	6508                	ld	a0,8(a0)
     830:	fbbff0ef          	jal	7ea <nulterminate>
    *rcmd->efile = 0;
     834:	6c9c                	ld	a5,24(s1)
     836:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83a:	8526                	mv	a0,s1
     83c:	60e2                	ld	ra,24(sp)
     83e:	6442                	ld	s0,16(sp)
     840:	64a2                	ld	s1,8(sp)
     842:	6105                	addi	sp,sp,32
     844:	8082                	ret
    nulterminate(pcmd->left);
     846:	6508                	ld	a0,8(a0)
     848:	fa3ff0ef          	jal	7ea <nulterminate>
    nulterminate(pcmd->right);
     84c:	6888                	ld	a0,16(s1)
     84e:	f9dff0ef          	jal	7ea <nulterminate>
    break;
     852:	b7e5                	j	83a <nulterminate+0x50>
    nulterminate(lcmd->left);
     854:	6508                	ld	a0,8(a0)
     856:	f95ff0ef          	jal	7ea <nulterminate>
    nulterminate(lcmd->right);
     85a:	6888                	ld	a0,16(s1)
     85c:	f8fff0ef          	jal	7ea <nulterminate>
    break;
     860:	bfe9                	j	83a <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     862:	6508                	ld	a0,8(a0)
     864:	f87ff0ef          	jal	7ea <nulterminate>
    break;
     868:	bfc9                	j	83a <nulterminate+0x50>

000000000000086a <parsecmd>:
{
     86a:	7139                	addi	sp,sp,-64
     86c:	fc06                	sd	ra,56(sp)
     86e:	f822                	sd	s0,48(sp)
     870:	f426                	sd	s1,40(sp)
     872:	f04a                	sd	s2,32(sp)
     874:	ec4e                	sd	s3,24(sp)
     876:	0080                	addi	s0,sp,64
     878:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     87c:	84aa                	mv	s1,a0
     87e:	192000ef          	jal	a10 <strlen>
     882:	1502                	slli	a0,a0,0x20
     884:	9101                	srli	a0,a0,0x20
     886:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     888:	fc840993          	addi	s3,s0,-56
     88c:	85a6                	mv	a1,s1
     88e:	854e                	mv	a0,s3
     890:	e4fff0ef          	jal	6de <parseline>
     894:	892a                	mv	s2,a0
  peek(&s, es, "");
     896:	00001617          	auipc	a2,0x1
     89a:	9d260613          	addi	a2,a2,-1582 # 1268 <malloc+0x108>
     89e:	85a6                	mv	a1,s1
     8a0:	854e                	mv	a0,s3
     8a2:	babff0ef          	jal	44c <peek>
  if(s != es){
     8a6:	fc843603          	ld	a2,-56(s0)
     8aa:	00961d63          	bne	a2,s1,8c4 <parsecmd+0x5a>
  nulterminate(cmd);
     8ae:	854a                	mv	a0,s2
     8b0:	f3bff0ef          	jal	7ea <nulterminate>
}
     8b4:	854a                	mv	a0,s2
     8b6:	70e2                	ld	ra,56(sp)
     8b8:	7442                	ld	s0,48(sp)
     8ba:	74a2                	ld	s1,40(sp)
     8bc:	7902                	ld	s2,32(sp)
     8be:	69e2                	ld	s3,24(sp)
     8c0:	6121                	addi	sp,sp,64
     8c2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c4:	00001597          	auipc	a1,0x1
     8c8:	a8458593          	addi	a1,a1,-1404 # 1348 <malloc+0x1e8>
     8cc:	4509                	li	a0,2
     8ce:	7b0000ef          	jal	107e <fprintf>
    panic("syntax");
     8d2:	00001517          	auipc	a0,0x1
     8d6:	a0e50513          	addi	a0,a0,-1522 # 12e0 <malloc+0x180>
     8da:	f70ff0ef          	jal	4a <panic>

00000000000008de <main>:
{
     8de:	7139                	addi	sp,sp,-64
     8e0:	fc06                	sd	ra,56(sp)
     8e2:	f822                	sd	s0,48(sp)
     8e4:	f426                	sd	s1,40(sp)
     8e6:	f04a                	sd	s2,32(sp)
     8e8:	ec4e                	sd	s3,24(sp)
     8ea:	e852                	sd	s4,16(sp)
     8ec:	e456                	sd	s5,8(sp)
     8ee:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8f0:	4489                	li	s1,2
     8f2:	00001917          	auipc	s2,0x1
     8f6:	a6690913          	addi	s2,s2,-1434 # 1358 <malloc+0x1f8>
     8fa:	85a6                	mv	a1,s1
     8fc:	854a                	mv	a0,s2
     8fe:	3a8000ef          	jal	ca6 <open>
     902:	00054663          	bltz	a0,90e <main+0x30>
    if(fd >= 3){
     906:	fea4dae3          	bge	s1,a0,8fa <main+0x1c>
      close(fd);
     90a:	384000ef          	jal	c8e <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     90e:	00001497          	auipc	s1,0x1
     912:	71248493          	addi	s1,s1,1810 # 2020 <buf.0>
     916:	06400913          	li	s2,100
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     91a:	06300993          	li	s3,99
     91e:	02000a13          	li	s4,32
     922:	a039                	j	930 <main+0x52>
    if(fork1() == 0)
     924:	f44ff0ef          	jal	68 <fork1>
     928:	c925                	beqz	a0,998 <main+0xba>
    wait(0);
     92a:	4501                	li	a0,0
     92c:	342000ef          	jal	c6e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     930:	85ca                	mv	a1,s2
     932:	8526                	mv	a0,s1
     934:	eccff0ef          	jal	0 <getcmd>
     938:	06054863          	bltz	a0,9a8 <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     93c:	0004c783          	lbu	a5,0(s1)
     940:	ff3792e3          	bne	a5,s3,924 <main+0x46>
     944:	0014c783          	lbu	a5,1(s1)
     948:	fd279ee3          	bne	a5,s2,924 <main+0x46>
     94c:	0024c783          	lbu	a5,2(s1)
     950:	fd479ae3          	bne	a5,s4,924 <main+0x46>
      buf[strlen(buf)-1] = 0;  // chop \n
     954:	00001a97          	auipc	s5,0x1
     958:	6cca8a93          	addi	s5,s5,1740 # 2020 <buf.0>
     95c:	8556                	mv	a0,s5
     95e:	0b2000ef          	jal	a10 <strlen>
     962:	fff5079b          	addiw	a5,a0,-1
     966:	1782                	slli	a5,a5,0x20
     968:	9381                	srli	a5,a5,0x20
     96a:	9abe                	add	s5,s5,a5
     96c:	000a8023          	sb	zero,0(s5)
      if(chdir(buf+3) < 0)
     970:	00001517          	auipc	a0,0x1
     974:	6b350513          	addi	a0,a0,1715 # 2023 <buf.0+0x3>
     978:	35e000ef          	jal	cd6 <chdir>
     97c:	fa055ae3          	bgez	a0,930 <main+0x52>
        fprintf(2, "cannot cd %s\n", buf+3);
     980:	00001617          	auipc	a2,0x1
     984:	6a360613          	addi	a2,a2,1699 # 2023 <buf.0+0x3>
     988:	00001597          	auipc	a1,0x1
     98c:	9d858593          	addi	a1,a1,-1576 # 1360 <malloc+0x200>
     990:	4509                	li	a0,2
     992:	6ec000ef          	jal	107e <fprintf>
     996:	bf69                	j	930 <main+0x52>
      runcmd(parsecmd(buf));
     998:	00001517          	auipc	a0,0x1
     99c:	68850513          	addi	a0,a0,1672 # 2020 <buf.0>
     9a0:	ecbff0ef          	jal	86a <parsecmd>
     9a4:	eeaff0ef          	jal	8e <runcmd>
  exit(0);
     9a8:	4501                	li	a0,0
     9aa:	2bc000ef          	jal	c66 <exit>

00000000000009ae <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     9ae:	1141                	addi	sp,sp,-16
     9b0:	e406                	sd	ra,8(sp)
     9b2:	e022                	sd	s0,0(sp)
     9b4:	0800                	addi	s0,sp,16
  extern int main();
  main();
     9b6:	f29ff0ef          	jal	8de <main>
  exit(0);
     9ba:	4501                	li	a0,0
     9bc:	2aa000ef          	jal	c66 <exit>

00000000000009c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9c0:	1141                	addi	sp,sp,-16
     9c2:	e406                	sd	ra,8(sp)
     9c4:	e022                	sd	s0,0(sp)
     9c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9c8:	87aa                	mv	a5,a0
     9ca:	0585                	addi	a1,a1,1
     9cc:	0785                	addi	a5,a5,1
     9ce:	fff5c703          	lbu	a4,-1(a1)
     9d2:	fee78fa3          	sb	a4,-1(a5)
     9d6:	fb75                	bnez	a4,9ca <strcpy+0xa>
    ;
  return os;
}
     9d8:	60a2                	ld	ra,8(sp)
     9da:	6402                	ld	s0,0(sp)
     9dc:	0141                	addi	sp,sp,16
     9de:	8082                	ret

00000000000009e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9e0:	1141                	addi	sp,sp,-16
     9e2:	e406                	sd	ra,8(sp)
     9e4:	e022                	sd	s0,0(sp)
     9e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9e8:	00054783          	lbu	a5,0(a0)
     9ec:	cb91                	beqz	a5,a00 <strcmp+0x20>
     9ee:	0005c703          	lbu	a4,0(a1)
     9f2:	00f71763          	bne	a4,a5,a00 <strcmp+0x20>
    p++, q++;
     9f6:	0505                	addi	a0,a0,1
     9f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9fa:	00054783          	lbu	a5,0(a0)
     9fe:	fbe5                	bnez	a5,9ee <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a00:	0005c503          	lbu	a0,0(a1)
}
     a04:	40a7853b          	subw	a0,a5,a0
     a08:	60a2                	ld	ra,8(sp)
     a0a:	6402                	ld	s0,0(sp)
     a0c:	0141                	addi	sp,sp,16
     a0e:	8082                	ret

0000000000000a10 <strlen>:

uint
strlen(const char *s)
{
     a10:	1141                	addi	sp,sp,-16
     a12:	e406                	sd	ra,8(sp)
     a14:	e022                	sd	s0,0(sp)
     a16:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a18:	00054783          	lbu	a5,0(a0)
     a1c:	cf99                	beqz	a5,a3a <strlen+0x2a>
     a1e:	0505                	addi	a0,a0,1
     a20:	87aa                	mv	a5,a0
     a22:	86be                	mv	a3,a5
     a24:	0785                	addi	a5,a5,1
     a26:	fff7c703          	lbu	a4,-1(a5)
     a2a:	ff65                	bnez	a4,a22 <strlen+0x12>
     a2c:	40a6853b          	subw	a0,a3,a0
     a30:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a32:	60a2                	ld	ra,8(sp)
     a34:	6402                	ld	s0,0(sp)
     a36:	0141                	addi	sp,sp,16
     a38:	8082                	ret
  for(n = 0; s[n]; n++)
     a3a:	4501                	li	a0,0
     a3c:	bfdd                	j	a32 <strlen+0x22>

0000000000000a3e <memset>:

void*
memset(void *dst, int c, uint n)
{
     a3e:	1141                	addi	sp,sp,-16
     a40:	e406                	sd	ra,8(sp)
     a42:	e022                	sd	s0,0(sp)
     a44:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a46:	ca19                	beqz	a2,a5c <memset+0x1e>
     a48:	87aa                	mv	a5,a0
     a4a:	1602                	slli	a2,a2,0x20
     a4c:	9201                	srli	a2,a2,0x20
     a4e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a52:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a56:	0785                	addi	a5,a5,1
     a58:	fee79de3          	bne	a5,a4,a52 <memset+0x14>
  }
  return dst;
}
     a5c:	60a2                	ld	ra,8(sp)
     a5e:	6402                	ld	s0,0(sp)
     a60:	0141                	addi	sp,sp,16
     a62:	8082                	ret

0000000000000a64 <strchr>:

char*
strchr(const char *s, char c)
{
     a64:	1141                	addi	sp,sp,-16
     a66:	e406                	sd	ra,8(sp)
     a68:	e022                	sd	s0,0(sp)
     a6a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a6c:	00054783          	lbu	a5,0(a0)
     a70:	cf81                	beqz	a5,a88 <strchr+0x24>
    if(*s == c)
     a72:	00f58763          	beq	a1,a5,a80 <strchr+0x1c>
  for(; *s; s++)
     a76:	0505                	addi	a0,a0,1
     a78:	00054783          	lbu	a5,0(a0)
     a7c:	fbfd                	bnez	a5,a72 <strchr+0xe>
      return (char*)s;
  return 0;
     a7e:	4501                	li	a0,0
}
     a80:	60a2                	ld	ra,8(sp)
     a82:	6402                	ld	s0,0(sp)
     a84:	0141                	addi	sp,sp,16
     a86:	8082                	ret
  return 0;
     a88:	4501                	li	a0,0
     a8a:	bfdd                	j	a80 <strchr+0x1c>

0000000000000a8c <gets>:

char*
gets(char *buf, int max)
{
     a8c:	7159                	addi	sp,sp,-112
     a8e:	f486                	sd	ra,104(sp)
     a90:	f0a2                	sd	s0,96(sp)
     a92:	eca6                	sd	s1,88(sp)
     a94:	e8ca                	sd	s2,80(sp)
     a96:	e4ce                	sd	s3,72(sp)
     a98:	e0d2                	sd	s4,64(sp)
     a9a:	fc56                	sd	s5,56(sp)
     a9c:	f85a                	sd	s6,48(sp)
     a9e:	f45e                	sd	s7,40(sp)
     aa0:	f062                	sd	s8,32(sp)
     aa2:	ec66                	sd	s9,24(sp)
     aa4:	e86a                	sd	s10,16(sp)
     aa6:	1880                	addi	s0,sp,112
     aa8:	8caa                	mv	s9,a0
     aaa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aac:	892a                	mv	s2,a0
     aae:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ab0:	f9f40b13          	addi	s6,s0,-97
     ab4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ab6:	4ba9                	li	s7,10
     ab8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     aba:	8d26                	mv	s10,s1
     abc:	0014899b          	addiw	s3,s1,1
     ac0:	84ce                	mv	s1,s3
     ac2:	0349d563          	bge	s3,s4,aec <gets+0x60>
    cc = read(0, &c, 1);
     ac6:	8656                	mv	a2,s5
     ac8:	85da                	mv	a1,s6
     aca:	4501                	li	a0,0
     acc:	1b2000ef          	jal	c7e <read>
    if(cc < 1)
     ad0:	00a05e63          	blez	a0,aec <gets+0x60>
    buf[i++] = c;
     ad4:	f9f44783          	lbu	a5,-97(s0)
     ad8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     adc:	01778763          	beq	a5,s7,aea <gets+0x5e>
     ae0:	0905                	addi	s2,s2,1
     ae2:	fd879ce3          	bne	a5,s8,aba <gets+0x2e>
    buf[i++] = c;
     ae6:	8d4e                	mv	s10,s3
     ae8:	a011                	j	aec <gets+0x60>
     aea:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     aec:	9d66                	add	s10,s10,s9
     aee:	000d0023          	sb	zero,0(s10)
  return buf;
}
     af2:	8566                	mv	a0,s9
     af4:	70a6                	ld	ra,104(sp)
     af6:	7406                	ld	s0,96(sp)
     af8:	64e6                	ld	s1,88(sp)
     afa:	6946                	ld	s2,80(sp)
     afc:	69a6                	ld	s3,72(sp)
     afe:	6a06                	ld	s4,64(sp)
     b00:	7ae2                	ld	s5,56(sp)
     b02:	7b42                	ld	s6,48(sp)
     b04:	7ba2                	ld	s7,40(sp)
     b06:	7c02                	ld	s8,32(sp)
     b08:	6ce2                	ld	s9,24(sp)
     b0a:	6d42                	ld	s10,16(sp)
     b0c:	6165                	addi	sp,sp,112
     b0e:	8082                	ret

0000000000000b10 <stat>:

int
stat(const char *n, struct stat *st)
{
     b10:	1101                	addi	sp,sp,-32
     b12:	ec06                	sd	ra,24(sp)
     b14:	e822                	sd	s0,16(sp)
     b16:	e04a                	sd	s2,0(sp)
     b18:	1000                	addi	s0,sp,32
     b1a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b1c:	4581                	li	a1,0
     b1e:	188000ef          	jal	ca6 <open>
  if(fd < 0)
     b22:	02054263          	bltz	a0,b46 <stat+0x36>
     b26:	e426                	sd	s1,8(sp)
     b28:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b2a:	85ca                	mv	a1,s2
     b2c:	192000ef          	jal	cbe <fstat>
     b30:	892a                	mv	s2,a0
  close(fd);
     b32:	8526                	mv	a0,s1
     b34:	15a000ef          	jal	c8e <close>
  return r;
     b38:	64a2                	ld	s1,8(sp)
}
     b3a:	854a                	mv	a0,s2
     b3c:	60e2                	ld	ra,24(sp)
     b3e:	6442                	ld	s0,16(sp)
     b40:	6902                	ld	s2,0(sp)
     b42:	6105                	addi	sp,sp,32
     b44:	8082                	ret
    return -1;
     b46:	597d                	li	s2,-1
     b48:	bfcd                	j	b3a <stat+0x2a>

0000000000000b4a <atoi>:

int
atoi(const char *s)
{
     b4a:	1141                	addi	sp,sp,-16
     b4c:	e406                	sd	ra,8(sp)
     b4e:	e022                	sd	s0,0(sp)
     b50:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b52:	00054683          	lbu	a3,0(a0)
     b56:	fd06879b          	addiw	a5,a3,-48
     b5a:	0ff7f793          	zext.b	a5,a5
     b5e:	4625                	li	a2,9
     b60:	02f66963          	bltu	a2,a5,b92 <atoi+0x48>
     b64:	872a                	mv	a4,a0
  n = 0;
     b66:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b68:	0705                	addi	a4,a4,1
     b6a:	0025179b          	slliw	a5,a0,0x2
     b6e:	9fa9                	addw	a5,a5,a0
     b70:	0017979b          	slliw	a5,a5,0x1
     b74:	9fb5                	addw	a5,a5,a3
     b76:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b7a:	00074683          	lbu	a3,0(a4)
     b7e:	fd06879b          	addiw	a5,a3,-48
     b82:	0ff7f793          	zext.b	a5,a5
     b86:	fef671e3          	bgeu	a2,a5,b68 <atoi+0x1e>
  return n;
}
     b8a:	60a2                	ld	ra,8(sp)
     b8c:	6402                	ld	s0,0(sp)
     b8e:	0141                	addi	sp,sp,16
     b90:	8082                	ret
  n = 0;
     b92:	4501                	li	a0,0
     b94:	bfdd                	j	b8a <atoi+0x40>

0000000000000b96 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b96:	1141                	addi	sp,sp,-16
     b98:	e406                	sd	ra,8(sp)
     b9a:	e022                	sd	s0,0(sp)
     b9c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b9e:	02b57563          	bgeu	a0,a1,bc8 <memmove+0x32>
    while(n-- > 0)
     ba2:	00c05f63          	blez	a2,bc0 <memmove+0x2a>
     ba6:	1602                	slli	a2,a2,0x20
     ba8:	9201                	srli	a2,a2,0x20
     baa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bae:	872a                	mv	a4,a0
      *dst++ = *src++;
     bb0:	0585                	addi	a1,a1,1
     bb2:	0705                	addi	a4,a4,1
     bb4:	fff5c683          	lbu	a3,-1(a1)
     bb8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     bbc:	fee79ae3          	bne	a5,a4,bb0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bc0:	60a2                	ld	ra,8(sp)
     bc2:	6402                	ld	s0,0(sp)
     bc4:	0141                	addi	sp,sp,16
     bc6:	8082                	ret
    dst += n;
     bc8:	00c50733          	add	a4,a0,a2
    src += n;
     bcc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     bce:	fec059e3          	blez	a2,bc0 <memmove+0x2a>
     bd2:	fff6079b          	addiw	a5,a2,-1
     bd6:	1782                	slli	a5,a5,0x20
     bd8:	9381                	srli	a5,a5,0x20
     bda:	fff7c793          	not	a5,a5
     bde:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     be0:	15fd                	addi	a1,a1,-1
     be2:	177d                	addi	a4,a4,-1
     be4:	0005c683          	lbu	a3,0(a1)
     be8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bec:	fef71ae3          	bne	a4,a5,be0 <memmove+0x4a>
     bf0:	bfc1                	j	bc0 <memmove+0x2a>

0000000000000bf2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bf2:	1141                	addi	sp,sp,-16
     bf4:	e406                	sd	ra,8(sp)
     bf6:	e022                	sd	s0,0(sp)
     bf8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bfa:	ca0d                	beqz	a2,c2c <memcmp+0x3a>
     bfc:	fff6069b          	addiw	a3,a2,-1
     c00:	1682                	slli	a3,a3,0x20
     c02:	9281                	srli	a3,a3,0x20
     c04:	0685                	addi	a3,a3,1
     c06:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	0005c703          	lbu	a4,0(a1)
     c10:	00e79863          	bne	a5,a4,c20 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     c14:	0505                	addi	a0,a0,1
    p2++;
     c16:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c18:	fed518e3          	bne	a0,a3,c08 <memcmp+0x16>
  }
  return 0;
     c1c:	4501                	li	a0,0
     c1e:	a019                	j	c24 <memcmp+0x32>
      return *p1 - *p2;
     c20:	40e7853b          	subw	a0,a5,a4
}
     c24:	60a2                	ld	ra,8(sp)
     c26:	6402                	ld	s0,0(sp)
     c28:	0141                	addi	sp,sp,16
     c2a:	8082                	ret
  return 0;
     c2c:	4501                	li	a0,0
     c2e:	bfdd                	j	c24 <memcmp+0x32>

0000000000000c30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c30:	1141                	addi	sp,sp,-16
     c32:	e406                	sd	ra,8(sp)
     c34:	e022                	sd	s0,0(sp)
     c36:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c38:	f5fff0ef          	jal	b96 <memmove>
}
     c3c:	60a2                	ld	ra,8(sp)
     c3e:	6402                	ld	s0,0(sp)
     c40:	0141                	addi	sp,sp,16
     c42:	8082                	ret

0000000000000c44 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     c44:	1141                	addi	sp,sp,-16
     c46:	e406                	sd	ra,8(sp)
     c48:	e022                	sd	s0,0(sp)
     c4a:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     c4c:	040007b7          	lui	a5,0x4000
     c50:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdf75>
     c52:	07b2                	slli	a5,a5,0xc
}
     c54:	4388                	lw	a0,0(a5)
     c56:	60a2                	ld	ra,8(sp)
     c58:	6402                	ld	s0,0(sp)
     c5a:	0141                	addi	sp,sp,16
     c5c:	8082                	ret

0000000000000c5e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c5e:	4885                	li	a7,1
 ecall
     c60:	00000073          	ecall
 ret
     c64:	8082                	ret

0000000000000c66 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c66:	4889                	li	a7,2
 ecall
     c68:	00000073          	ecall
 ret
     c6c:	8082                	ret

0000000000000c6e <wait>:
.global wait
wait:
 li a7, SYS_wait
     c6e:	488d                	li	a7,3
 ecall
     c70:	00000073          	ecall
 ret
     c74:	8082                	ret

0000000000000c76 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c76:	4891                	li	a7,4
 ecall
     c78:	00000073          	ecall
 ret
     c7c:	8082                	ret

0000000000000c7e <read>:
.global read
read:
 li a7, SYS_read
     c7e:	4895                	li	a7,5
 ecall
     c80:	00000073          	ecall
 ret
     c84:	8082                	ret

0000000000000c86 <write>:
.global write
write:
 li a7, SYS_write
     c86:	48c1                	li	a7,16
 ecall
     c88:	00000073          	ecall
 ret
     c8c:	8082                	ret

0000000000000c8e <close>:
.global close
close:
 li a7, SYS_close
     c8e:	48d5                	li	a7,21
 ecall
     c90:	00000073          	ecall
 ret
     c94:	8082                	ret

0000000000000c96 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c96:	4899                	li	a7,6
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <exec>:
.global exec
exec:
 li a7, SYS_exec
     c9e:	489d                	li	a7,7
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <open>:
.global open
open:
 li a7, SYS_open
     ca6:	48bd                	li	a7,15
 ecall
     ca8:	00000073          	ecall
 ret
     cac:	8082                	ret

0000000000000cae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cae:	48c5                	li	a7,17
 ecall
     cb0:	00000073          	ecall
 ret
     cb4:	8082                	ret

0000000000000cb6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cb6:	48c9                	li	a7,18
 ecall
     cb8:	00000073          	ecall
 ret
     cbc:	8082                	ret

0000000000000cbe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cbe:	48a1                	li	a7,8
 ecall
     cc0:	00000073          	ecall
 ret
     cc4:	8082                	ret

0000000000000cc6 <link>:
.global link
link:
 li a7, SYS_link
     cc6:	48cd                	li	a7,19
 ecall
     cc8:	00000073          	ecall
 ret
     ccc:	8082                	ret

0000000000000cce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cce:	48d1                	li	a7,20
 ecall
     cd0:	00000073          	ecall
 ret
     cd4:	8082                	ret

0000000000000cd6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cd6:	48a5                	li	a7,9
 ecall
     cd8:	00000073          	ecall
 ret
     cdc:	8082                	ret

0000000000000cde <dup>:
.global dup
dup:
 li a7, SYS_dup
     cde:	48a9                	li	a7,10
 ecall
     ce0:	00000073          	ecall
 ret
     ce4:	8082                	ret

0000000000000ce6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ce6:	48ad                	li	a7,11
 ecall
     ce8:	00000073          	ecall
 ret
     cec:	8082                	ret

0000000000000cee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     cee:	48b1                	li	a7,12
 ecall
     cf0:	00000073          	ecall
 ret
     cf4:	8082                	ret

0000000000000cf6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     cf6:	48b5                	li	a7,13
 ecall
     cf8:	00000073          	ecall
 ret
     cfc:	8082                	ret

0000000000000cfe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cfe:	48b9                	li	a7,14
 ecall
     d00:	00000073          	ecall
 ret
     d04:	8082                	ret

0000000000000d06 <bind>:
.global bind
bind:
 li a7, SYS_bind
     d06:	48f5                	li	a7,29
 ecall
     d08:	00000073          	ecall
 ret
     d0c:	8082                	ret

0000000000000d0e <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
     d0e:	48f9                	li	a7,30
 ecall
     d10:	00000073          	ecall
 ret
     d14:	8082                	ret

0000000000000d16 <send>:
.global send
send:
 li a7, SYS_send
     d16:	48fd                	li	a7,31
 ecall
     d18:	00000073          	ecall
 ret
     d1c:	8082                	ret

0000000000000d1e <recv>:
.global recv
recv:
 li a7, SYS_recv
     d1e:	02000893          	li	a7,32
 ecall
     d22:	00000073          	ecall
 ret
     d26:	8082                	ret

0000000000000d28 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
     d28:	02100893          	li	a7,33
 ecall
     d2c:	00000073          	ecall
 ret
     d30:	8082                	ret

0000000000000d32 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
     d32:	02200893          	li	a7,34
 ecall
     d36:	00000073          	ecall
 ret
     d3a:	8082                	ret

0000000000000d3c <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     d3c:	02400893          	li	a7,36
 ecall
     d40:	00000073          	ecall
 ret
     d44:	8082                	ret

0000000000000d46 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d46:	1101                	addi	sp,sp,-32
     d48:	ec06                	sd	ra,24(sp)
     d4a:	e822                	sd	s0,16(sp)
     d4c:	1000                	addi	s0,sp,32
     d4e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d52:	4605                	li	a2,1
     d54:	fef40593          	addi	a1,s0,-17
     d58:	f2fff0ef          	jal	c86 <write>
}
     d5c:	60e2                	ld	ra,24(sp)
     d5e:	6442                	ld	s0,16(sp)
     d60:	6105                	addi	sp,sp,32
     d62:	8082                	ret

0000000000000d64 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d64:	7139                	addi	sp,sp,-64
     d66:	fc06                	sd	ra,56(sp)
     d68:	f822                	sd	s0,48(sp)
     d6a:	f426                	sd	s1,40(sp)
     d6c:	f04a                	sd	s2,32(sp)
     d6e:	ec4e                	sd	s3,24(sp)
     d70:	0080                	addi	s0,sp,64
     d72:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d74:	c299                	beqz	a3,d7a <printint+0x16>
     d76:	0605ce63          	bltz	a1,df2 <printint+0x8e>
  neg = 0;
     d7a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d7c:	fc040313          	addi	t1,s0,-64
  neg = 0;
     d80:	869a                	mv	a3,t1
  i = 0;
     d82:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     d84:	00000817          	auipc	a6,0x0
     d88:	62480813          	addi	a6,a6,1572 # 13a8 <digits>
     d8c:	88be                	mv	a7,a5
     d8e:	0017851b          	addiw	a0,a5,1
     d92:	87aa                	mv	a5,a0
     d94:	02c5f73b          	remuw	a4,a1,a2
     d98:	1702                	slli	a4,a4,0x20
     d9a:	9301                	srli	a4,a4,0x20
     d9c:	9742                	add	a4,a4,a6
     d9e:	00074703          	lbu	a4,0(a4)
     da2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     da6:	872e                	mv	a4,a1
     da8:	02c5d5bb          	divuw	a1,a1,a2
     dac:	0685                	addi	a3,a3,1
     dae:	fcc77fe3          	bgeu	a4,a2,d8c <printint+0x28>
  if(neg)
     db2:	000e0c63          	beqz	t3,dca <printint+0x66>
    buf[i++] = '-';
     db6:	fd050793          	addi	a5,a0,-48
     dba:	00878533          	add	a0,a5,s0
     dbe:	02d00793          	li	a5,45
     dc2:	fef50823          	sb	a5,-16(a0)
     dc6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     dca:	fff7899b          	addiw	s3,a5,-1
     dce:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     dd2:	fff4c583          	lbu	a1,-1(s1)
     dd6:	854a                	mv	a0,s2
     dd8:	f6fff0ef          	jal	d46 <putc>
  while(--i >= 0)
     ddc:	39fd                	addiw	s3,s3,-1
     dde:	14fd                	addi	s1,s1,-1
     de0:	fe09d9e3          	bgez	s3,dd2 <printint+0x6e>
}
     de4:	70e2                	ld	ra,56(sp)
     de6:	7442                	ld	s0,48(sp)
     de8:	74a2                	ld	s1,40(sp)
     dea:	7902                	ld	s2,32(sp)
     dec:	69e2                	ld	s3,24(sp)
     dee:	6121                	addi	sp,sp,64
     df0:	8082                	ret
    x = -xx;
     df2:	40b005bb          	negw	a1,a1
    neg = 1;
     df6:	4e05                	li	t3,1
    x = -xx;
     df8:	b751                	j	d7c <printint+0x18>

0000000000000dfa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dfa:	711d                	addi	sp,sp,-96
     dfc:	ec86                	sd	ra,88(sp)
     dfe:	e8a2                	sd	s0,80(sp)
     e00:	e4a6                	sd	s1,72(sp)
     e02:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     e04:	0005c483          	lbu	s1,0(a1)
     e08:	26048663          	beqz	s1,1074 <vprintf+0x27a>
     e0c:	e0ca                	sd	s2,64(sp)
     e0e:	fc4e                	sd	s3,56(sp)
     e10:	f852                	sd	s4,48(sp)
     e12:	f456                	sd	s5,40(sp)
     e14:	f05a                	sd	s6,32(sp)
     e16:	ec5e                	sd	s7,24(sp)
     e18:	e862                	sd	s8,16(sp)
     e1a:	e466                	sd	s9,8(sp)
     e1c:	8b2a                	mv	s6,a0
     e1e:	8a2e                	mv	s4,a1
     e20:	8bb2                	mv	s7,a2
  state = 0;
     e22:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e24:	4901                	li	s2,0
     e26:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e28:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e2c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e30:	06c00c93          	li	s9,108
     e34:	a00d                	j	e56 <vprintf+0x5c>
        putc(fd, c0);
     e36:	85a6                	mv	a1,s1
     e38:	855a                	mv	a0,s6
     e3a:	f0dff0ef          	jal	d46 <putc>
     e3e:	a019                	j	e44 <vprintf+0x4a>
    } else if(state == '%'){
     e40:	03598363          	beq	s3,s5,e66 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     e44:	0019079b          	addiw	a5,s2,1
     e48:	893e                	mv	s2,a5
     e4a:	873e                	mv	a4,a5
     e4c:	97d2                	add	a5,a5,s4
     e4e:	0007c483          	lbu	s1,0(a5)
     e52:	20048963          	beqz	s1,1064 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
     e56:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e5a:	fe0993e3          	bnez	s3,e40 <vprintf+0x46>
      if(c0 == '%'){
     e5e:	fd579ce3          	bne	a5,s5,e36 <vprintf+0x3c>
        state = '%';
     e62:	89be                	mv	s3,a5
     e64:	b7c5                	j	e44 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e66:	00ea06b3          	add	a3,s4,a4
     e6a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e6e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e70:	c681                	beqz	a3,e78 <vprintf+0x7e>
     e72:	9752                	add	a4,a4,s4
     e74:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e78:	03878e63          	beq	a5,s8,eb4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     e7c:	05978863          	beq	a5,s9,ecc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e80:	07500713          	li	a4,117
     e84:	0ee78263          	beq	a5,a4,f68 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e88:	07800713          	li	a4,120
     e8c:	12e78463          	beq	a5,a4,fb4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e90:	07000713          	li	a4,112
     e94:	14e78963          	beq	a5,a4,fe6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e98:	07300713          	li	a4,115
     e9c:	18e78863          	beq	a5,a4,102c <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     ea0:	02500713          	li	a4,37
     ea4:	04e79463          	bne	a5,a4,eec <vprintf+0xf2>
        putc(fd, '%');
     ea8:	85ba                	mv	a1,a4
     eaa:	855a                	mv	a0,s6
     eac:	e9bff0ef          	jal	d46 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	bf49                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     eb4:	008b8493          	addi	s1,s7,8
     eb8:	4685                	li	a3,1
     eba:	4629                	li	a2,10
     ebc:	000ba583          	lw	a1,0(s7)
     ec0:	855a                	mv	a0,s6
     ec2:	ea3ff0ef          	jal	d64 <printint>
     ec6:	8ba6                	mv	s7,s1
      state = 0;
     ec8:	4981                	li	s3,0
     eca:	bfad                	j	e44 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     ecc:	06400793          	li	a5,100
     ed0:	02f68963          	beq	a3,a5,f02 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ed4:	06c00793          	li	a5,108
     ed8:	04f68263          	beq	a3,a5,f1c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     edc:	07500793          	li	a5,117
     ee0:	0af68063          	beq	a3,a5,f80 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     ee4:	07800793          	li	a5,120
     ee8:	0ef68263          	beq	a3,a5,fcc <vprintf+0x1d2>
        putc(fd, '%');
     eec:	02500593          	li	a1,37
     ef0:	855a                	mv	a0,s6
     ef2:	e55ff0ef          	jal	d46 <putc>
        putc(fd, c0);
     ef6:	85a6                	mv	a1,s1
     ef8:	855a                	mv	a0,s6
     efa:	e4dff0ef          	jal	d46 <putc>
      state = 0;
     efe:	4981                	li	s3,0
     f00:	b791                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f02:	008b8493          	addi	s1,s7,8
     f06:	4685                	li	a3,1
     f08:	4629                	li	a2,10
     f0a:	000ba583          	lw	a1,0(s7)
     f0e:	855a                	mv	a0,s6
     f10:	e55ff0ef          	jal	d64 <printint>
        i += 1;
     f14:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     f16:	8ba6                	mv	s7,s1
      state = 0;
     f18:	4981                	li	s3,0
        i += 1;
     f1a:	b72d                	j	e44 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f1c:	06400793          	li	a5,100
     f20:	02f60763          	beq	a2,a5,f4e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f24:	07500793          	li	a5,117
     f28:	06f60963          	beq	a2,a5,f9a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f2c:	07800793          	li	a5,120
     f30:	faf61ee3          	bne	a2,a5,eec <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f34:	008b8493          	addi	s1,s7,8
     f38:	4681                	li	a3,0
     f3a:	4641                	li	a2,16
     f3c:	000ba583          	lw	a1,0(s7)
     f40:	855a                	mv	a0,s6
     f42:	e23ff0ef          	jal	d64 <printint>
        i += 2;
     f46:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f48:	8ba6                	mv	s7,s1
      state = 0;
     f4a:	4981                	li	s3,0
        i += 2;
     f4c:	bde5                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f4e:	008b8493          	addi	s1,s7,8
     f52:	4685                	li	a3,1
     f54:	4629                	li	a2,10
     f56:	000ba583          	lw	a1,0(s7)
     f5a:	855a                	mv	a0,s6
     f5c:	e09ff0ef          	jal	d64 <printint>
        i += 2;
     f60:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f62:	8ba6                	mv	s7,s1
      state = 0;
     f64:	4981                	li	s3,0
        i += 2;
     f66:	bdf9                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     f68:	008b8493          	addi	s1,s7,8
     f6c:	4681                	li	a3,0
     f6e:	4629                	li	a2,10
     f70:	000ba583          	lw	a1,0(s7)
     f74:	855a                	mv	a0,s6
     f76:	defff0ef          	jal	d64 <printint>
     f7a:	8ba6                	mv	s7,s1
      state = 0;
     f7c:	4981                	li	s3,0
     f7e:	b5d9                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f80:	008b8493          	addi	s1,s7,8
     f84:	4681                	li	a3,0
     f86:	4629                	li	a2,10
     f88:	000ba583          	lw	a1,0(s7)
     f8c:	855a                	mv	a0,s6
     f8e:	dd7ff0ef          	jal	d64 <printint>
        i += 1;
     f92:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f94:	8ba6                	mv	s7,s1
      state = 0;
     f96:	4981                	li	s3,0
        i += 1;
     f98:	b575                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f9a:	008b8493          	addi	s1,s7,8
     f9e:	4681                	li	a3,0
     fa0:	4629                	li	a2,10
     fa2:	000ba583          	lw	a1,0(s7)
     fa6:	855a                	mv	a0,s6
     fa8:	dbdff0ef          	jal	d64 <printint>
        i += 2;
     fac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     fae:	8ba6                	mv	s7,s1
      state = 0;
     fb0:	4981                	li	s3,0
        i += 2;
     fb2:	bd49                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     fb4:	008b8493          	addi	s1,s7,8
     fb8:	4681                	li	a3,0
     fba:	4641                	li	a2,16
     fbc:	000ba583          	lw	a1,0(s7)
     fc0:	855a                	mv	a0,s6
     fc2:	da3ff0ef          	jal	d64 <printint>
     fc6:	8ba6                	mv	s7,s1
      state = 0;
     fc8:	4981                	li	s3,0
     fca:	bdad                	j	e44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fcc:	008b8493          	addi	s1,s7,8
     fd0:	4681                	li	a3,0
     fd2:	4641                	li	a2,16
     fd4:	000ba583          	lw	a1,0(s7)
     fd8:	855a                	mv	a0,s6
     fda:	d8bff0ef          	jal	d64 <printint>
        i += 1;
     fde:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fe0:	8ba6                	mv	s7,s1
      state = 0;
     fe2:	4981                	li	s3,0
        i += 1;
     fe4:	b585                	j	e44 <vprintf+0x4a>
     fe6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fe8:	008b8d13          	addi	s10,s7,8
     fec:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ff0:	03000593          	li	a1,48
     ff4:	855a                	mv	a0,s6
     ff6:	d51ff0ef          	jal	d46 <putc>
  putc(fd, 'x');
     ffa:	07800593          	li	a1,120
     ffe:	855a                	mv	a0,s6
    1000:	d47ff0ef          	jal	d46 <putc>
    1004:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1006:	00000b97          	auipc	s7,0x0
    100a:	3a2b8b93          	addi	s7,s7,930 # 13a8 <digits>
    100e:	03c9d793          	srli	a5,s3,0x3c
    1012:	97de                	add	a5,a5,s7
    1014:	0007c583          	lbu	a1,0(a5)
    1018:	855a                	mv	a0,s6
    101a:	d2dff0ef          	jal	d46 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    101e:	0992                	slli	s3,s3,0x4
    1020:	34fd                	addiw	s1,s1,-1
    1022:	f4f5                	bnez	s1,100e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1024:	8bea                	mv	s7,s10
      state = 0;
    1026:	4981                	li	s3,0
    1028:	6d02                	ld	s10,0(sp)
    102a:	bd29                	j	e44 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    102c:	008b8993          	addi	s3,s7,8
    1030:	000bb483          	ld	s1,0(s7)
    1034:	cc91                	beqz	s1,1050 <vprintf+0x256>
        for(; *s; s++)
    1036:	0004c583          	lbu	a1,0(s1)
    103a:	c195                	beqz	a1,105e <vprintf+0x264>
          putc(fd, *s);
    103c:	855a                	mv	a0,s6
    103e:	d09ff0ef          	jal	d46 <putc>
        for(; *s; s++)
    1042:	0485                	addi	s1,s1,1
    1044:	0004c583          	lbu	a1,0(s1)
    1048:	f9f5                	bnez	a1,103c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    104a:	8bce                	mv	s7,s3
      state = 0;
    104c:	4981                	li	s3,0
    104e:	bbdd                	j	e44 <vprintf+0x4a>
          s = "(null)";
    1050:	00000497          	auipc	s1,0x0
    1054:	32048493          	addi	s1,s1,800 # 1370 <malloc+0x210>
        for(; *s; s++)
    1058:	02800593          	li	a1,40
    105c:	b7c5                	j	103c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    105e:	8bce                	mv	s7,s3
      state = 0;
    1060:	4981                	li	s3,0
    1062:	b3cd                	j	e44 <vprintf+0x4a>
    1064:	6906                	ld	s2,64(sp)
    1066:	79e2                	ld	s3,56(sp)
    1068:	7a42                	ld	s4,48(sp)
    106a:	7aa2                	ld	s5,40(sp)
    106c:	7b02                	ld	s6,32(sp)
    106e:	6be2                	ld	s7,24(sp)
    1070:	6c42                	ld	s8,16(sp)
    1072:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1074:	60e6                	ld	ra,88(sp)
    1076:	6446                	ld	s0,80(sp)
    1078:	64a6                	ld	s1,72(sp)
    107a:	6125                	addi	sp,sp,96
    107c:	8082                	ret

000000000000107e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    107e:	715d                	addi	sp,sp,-80
    1080:	ec06                	sd	ra,24(sp)
    1082:	e822                	sd	s0,16(sp)
    1084:	1000                	addi	s0,sp,32
    1086:	e010                	sd	a2,0(s0)
    1088:	e414                	sd	a3,8(s0)
    108a:	e818                	sd	a4,16(s0)
    108c:	ec1c                	sd	a5,24(s0)
    108e:	03043023          	sd	a6,32(s0)
    1092:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1096:	8622                	mv	a2,s0
    1098:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    109c:	d5fff0ef          	jal	dfa <vprintf>
}
    10a0:	60e2                	ld	ra,24(sp)
    10a2:	6442                	ld	s0,16(sp)
    10a4:	6161                	addi	sp,sp,80
    10a6:	8082                	ret

00000000000010a8 <printf>:

void
printf(const char *fmt, ...)
{
    10a8:	711d                	addi	sp,sp,-96
    10aa:	ec06                	sd	ra,24(sp)
    10ac:	e822                	sd	s0,16(sp)
    10ae:	1000                	addi	s0,sp,32
    10b0:	e40c                	sd	a1,8(s0)
    10b2:	e810                	sd	a2,16(s0)
    10b4:	ec14                	sd	a3,24(s0)
    10b6:	f018                	sd	a4,32(s0)
    10b8:	f41c                	sd	a5,40(s0)
    10ba:	03043823          	sd	a6,48(s0)
    10be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10c2:	00840613          	addi	a2,s0,8
    10c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ca:	85aa                	mv	a1,a0
    10cc:	4505                	li	a0,1
    10ce:	d2dff0ef          	jal	dfa <vprintf>
}
    10d2:	60e2                	ld	ra,24(sp)
    10d4:	6442                	ld	s0,16(sp)
    10d6:	6125                	addi	sp,sp,96
    10d8:	8082                	ret

00000000000010da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10da:	1141                	addi	sp,sp,-16
    10dc:	e406                	sd	ra,8(sp)
    10de:	e022                	sd	s0,0(sp)
    10e0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10e2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10e6:	00001797          	auipc	a5,0x1
    10ea:	f2a7b783          	ld	a5,-214(a5) # 2010 <freep>
    10ee:	a02d                	j	1118 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10f0:	4618                	lw	a4,8(a2)
    10f2:	9f2d                	addw	a4,a4,a1
    10f4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10f8:	6398                	ld	a4,0(a5)
    10fa:	6310                	ld	a2,0(a4)
    10fc:	a83d                	j	113a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10fe:	ff852703          	lw	a4,-8(a0)
    1102:	9f31                	addw	a4,a4,a2
    1104:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1106:	ff053683          	ld	a3,-16(a0)
    110a:	a091                	j	114e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    110c:	6398                	ld	a4,0(a5)
    110e:	00e7e463          	bltu	a5,a4,1116 <free+0x3c>
    1112:	00e6ea63          	bltu	a3,a4,1126 <free+0x4c>
{
    1116:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1118:	fed7fae3          	bgeu	a5,a3,110c <free+0x32>
    111c:	6398                	ld	a4,0(a5)
    111e:	00e6e463          	bltu	a3,a4,1126 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1122:	fee7eae3          	bltu	a5,a4,1116 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    1126:	ff852583          	lw	a1,-8(a0)
    112a:	6390                	ld	a2,0(a5)
    112c:	02059813          	slli	a6,a1,0x20
    1130:	01c85713          	srli	a4,a6,0x1c
    1134:	9736                	add	a4,a4,a3
    1136:	fae60de3          	beq	a2,a4,10f0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    113a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    113e:	4790                	lw	a2,8(a5)
    1140:	02061593          	slli	a1,a2,0x20
    1144:	01c5d713          	srli	a4,a1,0x1c
    1148:	973e                	add	a4,a4,a5
    114a:	fae68ae3          	beq	a3,a4,10fe <free+0x24>
    p->s.ptr = bp->s.ptr;
    114e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1150:	00001717          	auipc	a4,0x1
    1154:	ecf73023          	sd	a5,-320(a4) # 2010 <freep>
}
    1158:	60a2                	ld	ra,8(sp)
    115a:	6402                	ld	s0,0(sp)
    115c:	0141                	addi	sp,sp,16
    115e:	8082                	ret

0000000000001160 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1160:	7139                	addi	sp,sp,-64
    1162:	fc06                	sd	ra,56(sp)
    1164:	f822                	sd	s0,48(sp)
    1166:	f04a                	sd	s2,32(sp)
    1168:	ec4e                	sd	s3,24(sp)
    116a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    116c:	02051993          	slli	s3,a0,0x20
    1170:	0209d993          	srli	s3,s3,0x20
    1174:	09bd                	addi	s3,s3,15
    1176:	0049d993          	srli	s3,s3,0x4
    117a:	2985                	addiw	s3,s3,1
    117c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    117e:	00001517          	auipc	a0,0x1
    1182:	e9253503          	ld	a0,-366(a0) # 2010 <freep>
    1186:	c905                	beqz	a0,11b6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1188:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    118a:	4798                	lw	a4,8(a5)
    118c:	09377663          	bgeu	a4,s3,1218 <malloc+0xb8>
    1190:	f426                	sd	s1,40(sp)
    1192:	e852                	sd	s4,16(sp)
    1194:	e456                	sd	s5,8(sp)
    1196:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1198:	8a4e                	mv	s4,s3
    119a:	6705                	lui	a4,0x1
    119c:	00e9f363          	bgeu	s3,a4,11a2 <malloc+0x42>
    11a0:	6a05                	lui	s4,0x1
    11a2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11a6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11aa:	00001497          	auipc	s1,0x1
    11ae:	e6648493          	addi	s1,s1,-410 # 2010 <freep>
  if(p == (char*)-1)
    11b2:	5afd                	li	s5,-1
    11b4:	a83d                	j	11f2 <malloc+0x92>
    11b6:	f426                	sd	s1,40(sp)
    11b8:	e852                	sd	s4,16(sp)
    11ba:	e456                	sd	s5,8(sp)
    11bc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11be:	00001797          	auipc	a5,0x1
    11c2:	eca78793          	addi	a5,a5,-310 # 2088 <base>
    11c6:	00001717          	auipc	a4,0x1
    11ca:	e4f73523          	sd	a5,-438(a4) # 2010 <freep>
    11ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11d4:	b7d1                	j	1198 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11d6:	6398                	ld	a4,0(a5)
    11d8:	e118                	sd	a4,0(a0)
    11da:	a899                	j	1230 <malloc+0xd0>
  hp->s.size = nu;
    11dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11e0:	0541                	addi	a0,a0,16
    11e2:	ef9ff0ef          	jal	10da <free>
  return freep;
    11e6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11e8:	c125                	beqz	a0,1248 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11ec:	4798                	lw	a4,8(a5)
    11ee:	03277163          	bgeu	a4,s2,1210 <malloc+0xb0>
    if(p == freep)
    11f2:	6098                	ld	a4,0(s1)
    11f4:	853e                	mv	a0,a5
    11f6:	fef71ae3          	bne	a4,a5,11ea <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11fa:	8552                	mv	a0,s4
    11fc:	af3ff0ef          	jal	cee <sbrk>
  if(p == (char*)-1)
    1200:	fd551ee3          	bne	a0,s5,11dc <malloc+0x7c>
        return 0;
    1204:	4501                	li	a0,0
    1206:	74a2                	ld	s1,40(sp)
    1208:	6a42                	ld	s4,16(sp)
    120a:	6aa2                	ld	s5,8(sp)
    120c:	6b02                	ld	s6,0(sp)
    120e:	a03d                	j	123c <malloc+0xdc>
    1210:	74a2                	ld	s1,40(sp)
    1212:	6a42                	ld	s4,16(sp)
    1214:	6aa2                	ld	s5,8(sp)
    1216:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1218:	fae90fe3          	beq	s2,a4,11d6 <malloc+0x76>
        p->s.size -= nunits;
    121c:	4137073b          	subw	a4,a4,s3
    1220:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1222:	02071693          	slli	a3,a4,0x20
    1226:	01c6d713          	srli	a4,a3,0x1c
    122a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    122c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1230:	00001717          	auipc	a4,0x1
    1234:	dea73023          	sd	a0,-544(a4) # 2010 <freep>
      return (void*)(p + 1);
    1238:	01078513          	addi	a0,a5,16
  }
}
    123c:	70e2                	ld	ra,56(sp)
    123e:	7442                	ld	s0,48(sp)
    1240:	7902                	ld	s2,32(sp)
    1242:	69e2                	ld	s3,24(sp)
    1244:	6121                	addi	sp,sp,64
    1246:	8082                	ret
    1248:	74a2                	ld	s1,40(sp)
    124a:	6a42                	ld	s4,16(sp)
    124c:	6aa2                	ld	s5,8(sp)
    124e:	6b02                	ld	s6,0(sp)
    1250:	b7f5                	j	123c <malloc+0xdc>
