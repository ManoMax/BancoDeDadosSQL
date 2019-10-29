-- Entidades

CREATE TABLE CLIENTE (
    cpf CHAR(11) NOT NULL,
    nome varchar(50) NOT NULL,
    email varchar(30) NOT NULL,
    crm INT NOT NULL,
    PRIMARY KEY (cpf)
);
CREATE TABLE TELEFONE_CLIENTE (
    cpfCliente CHAR(11) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    PRIMARY KEY (cpfCliente, numero)
);
CREATE TABLE ENDERECO_CLIENTE (
    cpfCliente CHAR(11) NOT NULL,
    rua varchar(50) NOT NULL,
    num varchar(5) NOT NULL,
    bairro varchar(20) NOT NULL,
    cidade varchar(20) NOT NULL,
    estado varchar(20) NOT NULL,
    PRIMARY KEY (cpfCliente)
);

CREATE TABLE FUNCIONARIO (
    matricula INT NOT NULL,
    cpf CHAR(11) NOT NULL,
    identidade CHAR(7) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    salario NUMERIC(6,2) NOT NULL,
    funcao VARCHAR(15) NOT NULL,
    matrSupervisor INT,
    idFilial INT NOT NULL,
    PRIMARY KEY (matricula),
    CHECK (salario > 0)
);
CREATE TABLE TELEFONE_FUNCIONARIO (
    matFunc INT NOT NULL,
    numero VARCHAR(15) NOT NULL,
    PRIMARY KEY (matFunc, numero)
);
CREATE TABLE DEPENDENTE_FUNCIONARIO (
    cpf CHAR(11) NOT NULL,
    matFunc INT NOT NULL,
    nascimento DATE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    PRIMARY KEY (matFunc, cpf)
);

CREATE TABLE FILIAL (
    idFilial INT NOT NULL,
    gerente INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    PRIMARY KEY (idFilial)
);

CREATE TABLE CAIXA (
    numCaixa INT NOT NULL,
    idFilial INT NOT NULL,
    PRIMARY KEY (numCaixa)
);

CREATE TABLE EQUIPAMENTO (
    identificador INT NOT NULL,
    numCaixa INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    PRIMARY KEY(identificador)
);

CREATE TABLE PRODUTO (
    idProduto INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    margemLucro NUMERIC(6,2) NOT NULL,
    PRIMARY KEY(idProduto)
);
CREATE TABLE CATEGORIA_PRODUTO (
    idCategoria INT NOT NULL,
    idProduto INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    PRIMARY KEY(idProduto, idCategoria)
);
CREATE TABLE MARCA_PRODUTO (
    idMarca INT NOT NULL,
    idProduto INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    PRIMARY KEY(idProduto, idMarca)
);

CREATE TABLE ORDEM_DE_COMPRA (
    numNotaFiscal INT NOT NULL,
    cpfCliente CHAR(11) NOT NULL,
    matFuncionario INT NOT NULL,
    idFilial INT NOT NULL,
    numCaixa INT NOT NULL,
    data DATE NOT NULL,
    PRIMARY KEY(numNotaFiscal)
);

CREATE TABLE ITEM_DE_COMPRA (
    idItemComprado INT NOT NULL,
    numNotaFiscal INT NOT NULL,
    quantidade INT NOT NULL,
    precoProd NUMERIC(6,2) NOT NULL,
    desconto NUMERIC(6,2) NOT NULL,
    PRIMARY KEY(idItemComprado, numNotaFiscal)
);

-- Relacionamentos

CREATE TABLE FUNCIONARIO_POR_FILIAL (
    matFunc INT NOT NULL,
    idFilial INT NOT NULL,
    PRIMARY KEY (matFunc, idFilial)
);

CREATE TABLE RECLAMACAO_CLIENTE_FILIAL (
    cpfCliente CHAR(11) NOT NULL,
    idFilial INT NOT NULL,
    data DATE NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    PRIMARY KEY(cpfCliente, idFilial)
);

CREATE TABLE PLANO_DE_MANUTENCAO (
    numCaixa INT NOT NULL,
    identificadorEquip INT NOT NULL,
    descManutencao VARCHAR(150) NOT NULL,
    data DATE NOT NULL,
    custo NUMERIC(5,2) NOT NULL,
    PRIMARY KEY(numCaixa, identificadorEquip)
);

CREATE TABLE PRODUTO_POR_FILIAL (
    idFilial INT NOT NULL,
    idProduto INT NOT NULL,
    dataCompra DATE NOT NULL,
    dataValidade DATE NOT NULL,
    precoCompra NUMERIC(6,2) NOT NULL,
    precoVenda NUMERIC(6,2) NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY(idFilial, idProduto)
);

CREATE TABLE SOLICITACAO(
    idSolicitacao INT NOT NULL,
    dataSolicitacao DATE NOT NULL,
    dataPrevistaEntrega DATE NOT NULL,
    dataEntrega DATE NOT NULL,
    valorCompra NUMERIC(6,2) NOT NULL, 
    prazoPagamento INT NOT NULL,
    codFilial INT NOT NULL,
    PRIMARY KEY(idSolicitacao)

);

CREATE TABLE NOTA_FISCAL(
    idNotaFiscal INT NOT NULL,
    cnpj CHAR(14) NOT NULL,
    quantidade INT NOT NULL,
    dataCompra DATE NOT NULL,
    valorCompra NUMERIC (6,2) NOT NULL,
    PRIMARY KEY(idNotaFiscal)

);

-- Referenciamentos / Contratos

ALTER TABLE TELEFONE_CLIENTE ADD CONSTRAINT CPFClienteTelefone FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf);
ALTER TABLE ENDERECO_CLIENTE ADD CONSTRAINT CPFClienteEndereco FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf);

ALTER TABLE FUNCIONARIO ADD CONSTRAINT MatrSupervisorFuncionario FOREIGN KEY(matrSupervisor) REFERENCES FUNCIONARIO(matricula);

ALTER TABLE TELEFONE_FUNCIONARIO ADD CONSTRAINT MatriculaTelefoneFuncionario FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula);
ALTER TABLE DEPENDENTE_FUNCIONARIO ADD CONSTRAINT DependenteFuncionario FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula);

ALTER TABLE FILIAL ADD CONSTRAINT GerenteFilial FOREIGN KEY(gerente) REFERENCES FUNCIONARIO(matricula);
ALTER TABLE FUNCIONARIO ADD CONSTRAINT IdFilialDoFuncionario FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);

ALTER TABLE FUNCIONARIO_POR_FILIAL ADD CONSTRAINT MatFuncPorFilial FOREIGN KEY(matFunc) REFERENCES FUNCIONARIO(matricula);
ALTER TABLE FUNCIONARIO_POR_FILIAL ADD CONSTRAINT IdFuncPorFilial FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);

ALTER TABLE RECLAMACAO_CLIENTE_FILIAL ADD CONSTRAINT CPFReclamacaoClienteFilial FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf);
ALTER TABLE RECLAMACAO_CLIENTE_FILIAL ADD CONSTRAINT IdReclamacaoClienteFilial FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);

ALTER TABLE CAIXA ADD CONSTRAINT IdFilialCaixa FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);
ALTER TABLE EQUIPAMENTO ADD CONSTRAINT NumCaixaEquipamento FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa);

ALTER TABLE PLANO_DE_MANUTENCAO ADD CONSTRAINT NumCaixaPlanoManutencao FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa);
ALTER TABLE PLANO_DE_MANUTENCAO ADD CONSTRAINT IndenEquipPlanoManutencao FOREIGN KEY(identificadorEquip) REFERENCES EQUIPAMENTO(identificador);

ALTER TABLE CATEGORIA_PRODUTO ADD CONSTRAINT IdProdutoCategoria FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto);
ALTER TABLE MARCA_PRODUTO ADD CONSTRAINT IdProdutoMarca FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto);

ALTER TABLE PRODUTO_POR_FILIAL ADD CONSTRAINT IdFilialEstoque FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);
ALTER TABLE PRODUTO_POR_FILIAL ADD CONSTRAINT IdProdutoEstoque FOREIGN KEY(idProduto) REFERENCES PRODUTO(idProduto);

ALTER TABLE ORDEM_DE_COMPRA ADD CONSTRAINT CPFClienteOrdemCompra FOREIGN KEY(cpfCliente) REFERENCES CLIENTE(cpf);
ALTER TABLE ORDEM_DE_COMPRA ADD CONSTRAINT MatFunciOrdemCompra FOREIGN KEY(matFuncionario) REFERENCES FUNCIONARIO(matricula);
ALTER TABLE ORDEM_DE_COMPRA ADD CONSTRAINT IdFilialOrdemCompra FOREIGN KEY(idFilial) REFERENCES FILIAL(idFilial);
ALTER TABLE ORDEM_DE_COMPRA ADD CONSTRAINT NumCaixaOrdemCompra FOREIGN KEY(numCaixa) REFERENCES CAIXA(numCaixa);

ALTER TABLE ITEM_DE_COMPRA ADD CONSTRAINT NumNotaFiscalItem FOREIGN KEY(numNotaFiscal) REFERENCES ORDEM_DE_COMPRA(numNotaFiscal);

ALTER TABLE SOLICITACAO ADD CONSTRAINT codNotaFiscalSolicitacao FOREING KEY(codNotaFiscal) REFERENCES NOTA_FISCAL (idNotaFiscal);
