#include <Vencode83.h>
#include <verilated.h>  
#include <verilated_fst_c.h> 

VerilatedContext* contextp = NULL;
VerilatedFstC* tfp = NULL;
static Vencode83* top;

void step_and_dump_wave(){
    top->eval();             
    contextp->timeInc(1);    
    tfp->dump(contextp->time()); 
}

void sim_init(){
    contextp = new VerilatedContext;
    tfp = new VerilatedFstC;
    top = new Vencode83;
    contextp->traceEverOn(true);
    top->trace(tfp, 0);
    tfp->open("encode83.fst");
}

void sim_exit(){
    step_and_dump_wave();
    tfp->close();
}

int main() {
    sim_init();

    top->en = 0b0;  top->in = 0b00000000;  step_and_dump_wave();
                    top->in = 0b00000001;  step_and_dump_wave();
                    top->in = 0b00000010;  step_and_dump_wave();
                    top->in = 0b00000011;  step_and_dump_wave();
                    top->in = 0b00000100;  step_and_dump_wave();
                    top->in = 0b00000110;  step_and_dump_wave();
                    top->in = 0b00001000;  step_and_dump_wave();
                    top->in = 0b00001100;  step_and_dump_wave();
                    top->in = 0b00010000;  step_and_dump_wave();
                    top->in = 0b00010001;  step_and_dump_wave();
                    top->in = 0b00100000;  step_and_dump_wave();
                    top->in = 0b00100010;  step_and_dump_wave();
                    top->in = 0b01000000;  step_and_dump_wave();
                    top->in = 0b01000100;  step_and_dump_wave();
                    top->in = 0b10000000;  step_and_dump_wave();
                    top->in = 0b10001000;  step_and_dump_wave();
    top->en = 0b1;  top->in = 0b00000000;  step_and_dump_wave();
                    top->in = 0b00000001;  step_and_dump_wave();
                    top->in = 0b00000010;  step_and_dump_wave();
                    top->in = 0b00000011;  step_and_dump_wave();
                    top->in = 0b00000100;  step_and_dump_wave();
                    top->in = 0b00000110;  step_and_dump_wave();
                    top->in = 0b00001000;  step_and_dump_wave();
                    top->in = 0b00001100;  step_and_dump_wave();
                    top->in = 0b00010000;  step_and_dump_wave();
                    top->in = 0b00010001;  step_and_dump_wave();
                    top->in = 0b00100000;  step_and_dump_wave();
                    top->in = 0b00100010;  step_and_dump_wave();
                    top->in = 0b01000000;  step_and_dump_wave();
                    top->in = 0b01000100;  step_and_dump_wave();
                    top->in = 0b10000000;  step_and_dump_wave();
                    top->in = 0b10001000;  step_and_dump_wave();

    sim_exit();
}
