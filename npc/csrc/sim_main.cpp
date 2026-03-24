#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include"Vtop.h"
#include <verilated.h>  
#include <verilated_fst_c.h> 

#define max_time 20   //最大仿真时间
vluint64_t current_time = 0;
int main(int argc, char** argv) {
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vtop* top = new Vtop{contextp};
    Verilated::traceEverOn(true);
    VerilatedFstC *m_trace = new VerilatedFstC;
    top->trace(m_trace, 5);
    m_trace->open("top.fst");
    
    while (current_time < max_time) {
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
    top->final();
    delete top;
    delete m_trace;
    return 0;
}
