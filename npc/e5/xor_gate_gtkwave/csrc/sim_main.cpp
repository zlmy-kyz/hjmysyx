#include<assert.h>
#include"Vtop.h"
#include <verilated.h>  
#include <verilated_fst_c.h> 
#define max_time 20   
vluint64_t current_time = 0;

void nvboard_bind_all_pins(Vtop* top);

int main(int argc, char** argv) {
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vtop* top = new Vtop{contextp};


    Verilated::traceEverOn(true);
    VerilatedFstC *m_trace = new VerilatedFstC;
    top->trace(m_trace, 5);
    m_trace->open("top.fst");
    
    while (current_time < max_time ) {

        top->eval();
        int a = rand() & 1;
        int b = rand() & 1;
        top->a = a;
        top->b = b;
        top->eval();
        m_trace->dump(current_time);
        current_time++;
        printf("a = %d, b = %d, f = %d\n", a, b, top->f);
        assert(top->f == (a ^ b));
        
    }
    m_trace->close();
    delete m_trace;
    top->final();
    delete top;
    return 0;
}