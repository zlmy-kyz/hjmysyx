#include<stdio.h>
#include<stdint.h>
#include<string.h>
#include<stdlib.h>
#define MEM_SIZE 150000000

uint32_t PC = 0;
uint32_t R[32] = {};
uint32_t ROM[MEM_SIZE] = {0};
uint32_t RAM[MEM_SIZE] = {0};
int end_flag = 0;

// 从二进制文件加载到 ROM 和 RAM
void load_bin(const char *path) {
    FILE *f = fopen(path, "rb");
    if (!f) {
        perror(path);
        exit(1);
    }

    uint32_t addr = 0;
    int c;

    while ((c = fgetc(f)) != EOF) {
        if (addr >> 2 < MEM_SIZE) {
            uint32_t word = ROM[addr >> 2];
            word |= ((uint32_t)(uint8_t)c) << ((addr % 4) * 8);
            ROM[addr >> 2] = word;
            RAM[addr >> 2] = word;
        }
        addr++;
    }
    fclose(f);
}

void riscv(){        
    if ((PC >> 2) >= MEM_SIZE) {
        fprintf(stderr, "PC out of bounds: 0x%08X\n", PC);
        exit(1);
    }		

	uint32_t inst = ROM[PC >> 2];
	uint32_t op = inst & 0x0000007F;
	uint32_t rd = (inst & 0x00000F80) >> 7;
	uint32_t rs1 = (inst & 0x000F8000) >> 15;
	uint32_t rs2 = (inst & 0x01F00000) >> 20;
	int32_t a_j_bu_w_imm = (int32_t)(inst & 0xFFF00000) >> 20;
	int32_t lui_imm = inst & 0xFFFFF000;
	uint32_t funct3 = (inst & 0x00007000) >> 12;
	uint32_t imm_high = (inst >> 25) & 0x7F;
	uint32_t imm_low = (inst >> 7) & 0x1F;
	uint32_t imm_12bit = (imm_high << 5) | imm_low;
	int32_t sw_sb_imm  = (int32_t)(imm_12bit << 20) >> 20;	
	switch(op){
		case 51:{//add指令操作码 0110011
            printf("pc = 0x%08X: ", PC);
            printf("inst = 0x%08X ", inst);

            if (rd !=0) {
                R[rd] = R[rs1] + R[rs2];//寄存器值相加
                printf("add x%d, x%d, x%d -> x%d = 0 (x0 is always 0)\n", rd, rs1, rs2, rd);
                PC += 4;
                break;
            }
            else {
                printf("add x%d, x%d, x%d -> x%d = 0 (x0 is always 0)\n", rd, rs1, rs2, rd);
                PC += 4;
                break;
            }

        }
		case 19:{//addi指令操作码0010011
            printf("pc = 0x%08X: ", PC);
            printf("inst = 0x%08X ", inst);

            if (rd == 0) {
                printf("addi x%d, x%d, %d -> x%d = 0 (x0 is always 0)\n", rd, rs1, a_j_bu_w_imm, rd);
                PC += 4;
                break;
            }
            else {
			    R[rd] = R[rs1] + a_j_bu_w_imm;//加立即数
                printf("addi x%d, x%d, %d -> x%d = %d\n", rd, rs1, a_j_bu_w_imm, rd, R[rd]);
			    PC += 4;
			    break;
            }

        }
		case 55:{//lui指令操作码 0110111

            printf("pc = 0x%08X: ", PC);
            printf("inst = 0x%08X ", inst);

            if (rd == 0){
                printf("lui x%d, %d -> x%d = 0 (x0 is always 0)\n", rd, lui_imm >> 12, rd);
                PC += 4;
                break;
            }
            else {
			    R[rd] = lui_imm;
                printf("lui x%d, %d -> x%d = 0x%08X\n", rd, lui_imm >> 12, rd, R[rd]);
			    PC += 4;
			    break;
            }

        }
		case 103:{//jalr指令操作码1100111

            printf("pc = 0x%08X: ", PC);
            printf("inst = 0x%08X ", inst);
			uint32_t temp = PC + 4;

			PC = (R[rs1] + a_j_bu_w_imm) & 0xFFFFFFFE;
            if (rd != 0){
                R[rd] = temp;
            }
            printf("jalr x%d, %d(x%d) -> x%d = 0x%08X, PC = 0x%08X\n", rd, a_j_bu_w_imm, rs1, rd, R[rd], PC);
			break;

        }
		case 3: {//lw_lbu指令操作码 0000011

            printf("pc = 0x%08X: ", PC);
			uint32_t addr = R[rs1] + a_j_bu_w_imm;    

            if ((addr >> 2) >= MEM_SIZE) {
                fprintf(stderr, "load address out of bounds: 0x%08X (PC=0x%08X)\n", addr, PC);
                exit(1);
            }			

            uint32_t byte = addr & 0x00000003;
            if (rd != 0){
			    if(funct3 == 2){//lw指令
				    R[rd] = RAM[addr >> 2];
                    printf("inst = 0x%08X ", inst);
                    printf("lw x%d, %d(x%d) -> x%d = 0x%08X\n", rd, a_j_bu_w_imm, rs1, rd, R[rd]);
				    PC += 4;
                    break;
			    }
			    else if(funct3 == 4){//lbu指令
                    printf("inst = 0x%08X ", inst);
				    R[rd] = (RAM[addr >> 2] >> (byte * 8)) & 0x000000FF;
                    printf("lbu x%d, %d(x%d) -> x%d = 0x%02X\n", rd, a_j_bu_w_imm, rs1, rd, R[rd]);
				    PC += 4;
                    break;
                }
            }

        }
		case 35: {//sb_sw指令操作码 0100011

            printf("pc = 0x%08X: ", PC);
			uint32_t addr1 = R[rs1] + sw_sb_imm;    

            if ((addr1 >> 2) >= MEM_SIZE) {
                fprintf(stderr, "store address out of bounds: 0x%08X (PC=0x%08X)\n", addr1, PC);
                exit(1);
            }			

            uint32_t byte1 = addr1 & 0x03;
			if (funct3 == 0){//sb指令
                printf("inst = 0x%08X ", inst);
				RAM[addr1 >> 2] = (RAM[addr1 >> 2] & ~(0xFF << (byte1 * 8))) | ((R[rs2] & 0xFF) << (byte1 * 8));
                printf("sb x%d, %d(x%d) -> RAM[0x%08X] = 0x%02X\n", rs2, sw_sb_imm, rs1, addr1, R[rs2] & 0xFF);
				PC += 4;
			}
			else if (funct3 == 2){//sw指令
                printf("inst = 0x%08X ", inst);
			    RAM[addr1 >> 2] = R[rs2];
                printf("sw x%d, %d(x%d) -> RAM[0x%08X] = 0x%08X\n", rs2, sw_sb_imm, rs1, addr1, R[rs2]);
				PC += 4;
			}
			break;	

        }
		case 115: {//ebreak指令
			if(inst == 0x00100073) { // ebreak
                if(R[10] == 0) { // a0 == 0
                    end_flag = 1;
                    printf("pc = 0x%08X: ", PC);
                    printf("inst = 0x%08X \n", inst);
                    printf("a0 = 0x%08X\n", R[10]);
                    printf("HIT GOOD TRAP! Program exited successfully.\n");
                }
				else {
                    end_flag = 1;
                    printf("pc = 0x%08X: ", PC);
                    printf("inst = 0x%08X \n", inst);
                    printf("a0 = 0x%08X\n", R[10]);
                    printf("HIT BAD TRAP! Program exited with error code: %d\n", R[10]);
                }
            
			    PC = MEM_SIZE * 4; // 强制退出循环
                break;
            }
			else {
                PC += 4;
                break;
            }
        }
        default:{
            printf("Unknown opcode 0x%02X at PC=0x%08X\n", op, PC);
            PC += 4;
            break;
		}
		}
		
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <binary-file>\n", argv[0]);
        return 1;
    }
    load_bin(argv[1]);

    /*uint32_t halt_addr = 0x1218;//mem程序halt函数在1218地址处，sum程序的halt函数在224地址处，执行到该地址时程序结束。若要打印ysyx图标，请先注释这4行代码。
    uint32_t ebreak = 0x00100073;
    ROM[halt_addr >> 2] = ebreak;
    RAM[halt_addr >> 2] = ebreak;*/

    
    uint64_t inst_count = 0;
    while (PC < MEM_SIZE * 4) {
        riscv();
        inst_count++;
        if(end_flag == 0){
            printf("x0=0x%08X ra=0x%08X sp=0x%08X gp=0x%08X tp=0x%08X t0=0x%08X t1=0x%08X t2=0x%08X s0=0x%08X s1=0x%08X a0=0x%08X a1=0x%08X a2=0x%08X a3=0x%08X a4=0x%08X a5=0x%08X\n",
               R[0], R[1], R[2], R[3], R[4], R[5], R[6], R[7], R[8], R[9], R[10], R[11], R[12], R[13], R[14], R[15]);
        }
        /*用于调试if (inst_count >= 20) {
            printf("-- 已执行20条指令，输入0继续 --\n");
            fflush(stdout);
            int cmd = 0;
            while (scanf("%d", &cmd) == 1) {
                if (cmd == 0) break;
            }
            inst_count = 0;
        }*/
    }
    return 0;
}
