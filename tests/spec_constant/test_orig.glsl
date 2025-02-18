#version 450

layout(local_size_x_id = 8) in;

layout(constant_id = 0) const bool TRUE = true;
layout(constant_id = 1) const bool FALSE = false;
layout(constant_id = 2) const int SONE = 1;
layout(constant_id = 3) const int STWO = 2;
layout(constant_id = 4) const int SNEG_TWO = -2;
layout(constant_id = 5) const uint UONE = 1;
layout(constant_id = 6) const uint UTWO = 2;
layout(constant_id = 7) const int SNEG_THREE = -3;

const uint IADD = SONE + STWO + UONE + UTWO; // 6
const uint ISUB = UTWO - SNEG_TWO;               // 4
const uint IMUL = UTWO * UTWO;               // 4
const uint UDIV = UTWO / UTWO;               // 1
const int SDIV = STWO / SNEG_THREE;            // 0
const int SREM = STWO % SNEG_THREE;          // 2, instruction changed in patch...
const int SMOD = STWO % SNEG_THREE;          // -1
const uint UMOD = IADD % IMUL;               // 2

const uint LSHL = IADD << (ISUB - 3);              // 12
const uint RSHL = IADD >> (ISUB - 3);              // 3
const int RSHA = (-int(IADD)) >> (1-SDIV);         // -3

const bool IEQ = IADD == (ISUB - 3);               // false
const bool INEQ = IADD != (ISUB - 3);              // true
const bool ULT = IADD < (ISUB - 3);                // false
const bool ULE = IADD <= (ISUB - 3);               // false
const bool UGT = IADD > (ISUB - 3);                // true
const bool UGE = IADD >= (ISUB - 3);               // true

const bool SLT = SMOD < SREM;                // true
const bool SLE = SMOD <= SREM;               // true
const bool SGT = SMOD > SREM;                // false
const bool SGE = SMOD >= SREM;               // false

const bool LOR = IEQ || SLT;                 // true
const bool LAND = IEQ && SLT;                // false
const bool LNOT = !LOR;                      // false

const uint AND = IADD & IADD;                // 6
const uint OR = IADD | (ISUB - 3);                 // 7
const uint XOR = IADD ^ IADD;                // 0
const uint NOT = ~XOR;                       // UINT_MAX

const bool LEQ = LAND == LNOT;               // true
const bool LNEQ = LAND != LNOT;              // false

const uint SEL = IEQ ? IADD : (ISUB - 3);          // 1

#define DUMMY_SSBO(name, bind, size) layout(std430, set = 0, binding = bind) buffer SSBO_##name { float val[size]; float dummy; } name

// Normalize all sizes to 1 element so that the default offsets in glslang matches up with what we should be computing.
// If we do it right, we should get no layout(offset = N) expressions.
DUMMY_SSBO(IAdd, 0, IADD - 5);
DUMMY_SSBO(ISub, 1, ISUB - 3);
DUMMY_SSBO(IMul, 2, IMUL - 3);
DUMMY_SSBO(UDiv, 3, UDIV);
DUMMY_SSBO(SDiv, 4, SDIV + 1);
DUMMY_SSBO(SRem, 5, SREM - 1);
DUMMY_SSBO(SMod, 6, SMOD + 2);
DUMMY_SSBO(UMod, 7, UMOD - 1);
DUMMY_SSBO(LShl, 8, LSHL - 11);
DUMMY_SSBO(RShl, 9, RSHL - 2);
DUMMY_SSBO(RSha, 10, RSHA + 4);
DUMMY_SSBO(IEq, 11, IEQ ? 2 : 1);
DUMMY_SSBO(INeq, 12, INEQ ? 1 : 2);
DUMMY_SSBO(Ult, 13, ULT ? 2 : 1);
DUMMY_SSBO(Ule, 14, ULE ? 2 : 1);
DUMMY_SSBO(Ugt, 15, UGT ? 1 : 2);
DUMMY_SSBO(Uge, 16, UGE ? 1 : 2);
DUMMY_SSBO(Slt, 17, SLT ? 1 : 2);
DUMMY_SSBO(Sle, 18, SLE ? 1 : 2);
DUMMY_SSBO(Sgt, 19, SGT ? 2 : 1);
DUMMY_SSBO(Sge, 20, SGE ? 2 : 1);
DUMMY_SSBO(Lor, 21, LOR ? 1 : 2);
DUMMY_SSBO(Land, 22, LAND ? 2 : 1);
DUMMY_SSBO(Lnot, 23, LNOT ? 2 : 1);
DUMMY_SSBO(And, 24, AND - 5);
DUMMY_SSBO(Or, 25, OR - 6);
DUMMY_SSBO(Xor, 26, XOR + 1);
DUMMY_SSBO(Not, 27, NOT - 0xfffffffeu);
DUMMY_SSBO(Leq, 28, LEQ ? 1 : 2);
DUMMY_SSBO(Lneq, 29, LNEQ ? 2 : 1);
DUMMY_SSBO(Sel, 30, SEL);

void main()
{
	IAdd.val[0] = 0.0;
	ISub.val[0] = 0.0;
	IMul.val[0] = 0.0;
	UDiv.val[0] = 0.0;
	SDiv.val[0] = 0.0;
	SRem.val[0] = 0.0;
	SMod.val[0] = 0.0;
	UMod.val[0] = 0.0;
	LShl.val[0] = 0.0;
	RShl.val[0] = 0.0;
	RSha.val[0] = 0.0;
	IEq.val[0] = 0.0;
	INeq.val[0] = 0.0;
	Ult.val[0] = 0.0;
	Ule.val[0] = 0.0;
	Ugt.val[0] = 0.0;
	Uge.val[0] = 0.0;
	Slt.val[0] = 0.0;
	Sle.val[0] = 0.0;
	Sgt.val[0] = 0.0;
	Sge.val[0] = 0.0;
	Lor.val[0] = 0.0;
	Land.val[0] = 0.0;
	Lnot.val[0] = 0.0;
	And.val[0] = 0.0;
	Or.val[0] = 0.0;
	Xor.val[0] = 0.0;
	Not.val[0] = 0.0;
	Leq.val[0] = 0.0;
	Lneq.val[0] = 0.0;
	Sel.val[0] = 0.0;
}