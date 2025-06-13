private import bicep

query predicate parameters(Parameter parameter) {
    any() 
}

query predicate parameter(Parameter param, Identifier name, string type) {
    param.getName() = name and
    param.getType().getType() = type 
}
