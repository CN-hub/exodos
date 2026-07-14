-- ============================================
-- ÊXODO - SISTEMA DE CONTROLE FISCAL
-- Banco de Dados Completo
-- 
-- Desenvolvido por: Cleilton Nascimento - CEO
-- Copyright © 2026 Raven Tech - Todos os direitos reservados
-- LOCALIZAÇÃO: Juazeiro do Norte - Ceará
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- ============================================
-- CRIAÇÃO DO BANCO
-- ============================================
CREATE DATABASE IF NOT EXISTS exodo_fiscal 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE exodo_fiscal;

-- ============================================
-- TABELA: USUÁRIOS
-- ============================================
CREATE TABLE IF NOT EXISTS usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    token_acesso VARCHAR(255) UNIQUE,
    token_validade DATETIME,
    ativo BOOLEAN DEFAULT TRUE,
    cargo ENUM('admin', 'contador', 'auxiliar') DEFAULT 'contador',
    ultimo_acesso DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: EMPRESAS
-- ============================================
CREATE TABLE IF NOT EXISTS empresas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    razao_social VARCHAR(200) NOT NULL,
    nome_fantasia VARCHAR(200),
    regime_tributario ENUM('Simples Nacional', 'Lucro Presumido', 'Lucro Real', 'MEI') NOT NULL,
    cnae VARCHAR(20),
    inscricao_estadual VARCHAR(20),
    inscricao_municipal VARCHAR(20),
    responsavel_id INT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (responsavel_id) REFERENCES usuarios(id)
);

-- ============================================
-- TABELA: COLETAS
-- ============================================
CREATE TABLE IF NOT EXISTS coletas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    usuario_id INT NOT NULL,
    data_coleta DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo_documento ENUM('XML', 'NFSe', 'Extrato', 'Comprovante', 'Outros', 'SPED') DEFAULT 'XML',
    arquivo_nome VARCHAR(255),
    arquivo_hash VARCHAR(64),
    status ENUM('pendente', 'coletado', 'validado', 'processado') DEFAULT 'pendente',
    observacoes TEXT,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ============================================
-- TABELA: FERIADOS
-- ============================================
CREATE TABLE IF NOT EXISTS feriados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data DATE UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('nacional', 'estadual', 'municipal') DEFAULT 'estadual',
    uf CHAR(2) DEFAULT 'CE'
);

-- ============================================
-- TABELA: CALENDÁRIO FISCAL
-- ============================================
CREATE TABLE IF NOT EXISTS calendario_fiscal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data DATE UNIQUE NOT NULL,
    descricao VARCHAR(200),
    prazo_final DATE,
    regime_tributario ENUM('Simples Nacional', 'Lucro Presumido', 'Lucro Real', 'Todos') DEFAULT 'Todos',
    tipo_obrigacao ENUM('SPED Fiscal', 'ECF', 'GIA', 'EFD ICMS/IPI', 'DAS', 'GPS')
);

-- ============================================
-- TABELA: BACKUPS
-- ============================================
CREATE TABLE IF NOT EXISTS backups (
    id INT PRIMARY KEY AUTO_INCREMENT,
    arquivo VARCHAR(255) NOT NULL,
    tamanho INT NOT NULL,
    data_backup DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('sucesso', 'falha') DEFAULT 'sucesso',
    observacoes TEXT
);

-- ============================================
-- TABELA: LOGS
-- ============================================
CREATE TABLE IF NOT EXISTS logs_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('info', 'warning', 'error', 'backup', 'update') DEFAULT 'info',
    mensagem TEXT NOT NULL,
    usuario_id INT NULL,
    ip VARCHAR(45) NULL,
    cidade VARCHAR(100) DEFAULT 'Juazeiro do Norte',
    regiao VARCHAR(100) DEFAULT 'Cariri Cearense',
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ============================================
-- TABELA: TOKENS EXTERNOS
-- ============================================
CREATE TABLE IF NOT EXISTS tokens_externos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    validade DATETIME NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ============================================
-- TABELA: NOTIFICAÇÕES
-- ============================================
CREATE TABLE IF NOT EXISTS notificacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    tipo ENUM('email', 'sms', 'sistema') DEFAULT 'email',
    descricao TEXT,
    enviado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- ============================================
-- TABELA: CONFIGURAÇÕES REGIONAIS
-- ============================================
CREATE TABLE IF NOT EXISTS config_regional (
    id INT PRIMARY KEY AUTO_INCREMENT,
    chave VARCHAR(50) UNIQUE NOT NULL,
    valor TEXT NOT NULL,
    descricao VARCHAR(200),
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: VERIFICAÇÕES DE ASSINATURA
-- ============================================
CREATE TABLE IF NOT EXISTS verificacoes_assinatura (
    id INT PRIMARY KEY AUTO_INCREMENT,
    arquivo VARCHAR(255) NOT NULL,
    hash_calculado VARCHAR(64) NOT NULL,
    status ENUM('verificado', 'invalido') DEFAULT 'verificado',
    verificado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    verificado_por INT NOT NULL,
    FOREIGN KEY (verificado_por) REFERENCES usuarios(id)
);

-- ============================================
-- TABELA: LOGS DE CONTATO
-- ============================================
CREATE TABLE IF NOT EXISTS logs_contato (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    assunto VARCHAR(100),
    mensagem TEXT,
    ip VARCHAR(45),
    user_agent VARCHAR(255),
    enviado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('enviado', 'lido', 'respondido') DEFAULT 'enviado'
);

-- ============================================
-- INSERTS INICIAIS
-- ============================================

-- Usuário Admin (senha: 123456)
INSERT INTO usuarios (nome, email, senha_hash, cargo, ativo) VALUES 
('Administrador', 'admin@exodo.com.br', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1);

INSERT INTO usuarios (nome, email, senha_hash, cargo, ativo) VALUES 
('Cleilton Nascimento', 'cleilton@ravetech.com.br', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1);

-- Feriados de Juazeiro do Norte - CE
INSERT INTO feriados (data, nome, tipo, uf) VALUES 
-- Nacionais
('2026-01-01', 'Confraternização Universal', 'nacional', 'BR'),
('2026-04-21', 'Tiradentes', 'nacional', 'BR'),
('2026-05-01', 'Dia do Trabalho', 'nacional', 'BR'),
('2026-09-07', 'Independência do Brasil', 'nacional', 'BR'),
('2026-10-12', 'Nossa Senhora Aparecida', 'nacional', 'BR'),
('2026-11-02', 'Finados', 'nacional', 'BR'),
('2026-11-15', 'Proclamação da República', 'nacional', 'BR'),
('2026-11-20', 'Dia da Consciência Negra', 'nacional', 'BR'),
('2026-12-25', 'Natal', 'nacional', 'BR'),
-- Estaduais (Ceará)
('2026-04-19', 'Dia do Índio', 'estadual', 'CE'),
('2026-08-25', 'São José - Padroeiro do Ceará', 'estadual', 'CE'),
('2026-12-08', 'Imaculada Conceição', 'estadual', 'CE'),
-- Municipais (Juazeiro do Norte)
('2026-04-20', 'Dia do Padre Cícero', 'municipal', 'CE'),
('2026-07-22', 'Aniversário de Juazeiro do Norte', 'municipal', 'CE'),
('2026-11-01', 'Dia de Todos os Santos', 'municipal', 'CE');

-- Configurações Regionais
INSERT INTO config_regional (chave, valor, descricao) VALUES 
('cidade', 'Juazeiro do Norte', 'Cidade sede'),
('estado', 'CE', 'Estado'),
('regiao', 'Cariri Cearense', 'Região'),
('feriados_municipais', '20-04,22-07,01-11', 'Feriados municipais'),
('padroeiro', 'Padre Cícero Romão Batista', 'Padroeiro da cidade'),
('data_fundacao', '1911-07-22', 'Data de fundação'),
('tipo_escritorio', 'Digital', 'Tipo de escritório'),
('modalidade', '100% Online', 'Modalidade de atendimento'),
('atendimento_horario', 'Segunda a Sexta - 08:00 às 18:00', 'Horário de atendimento'),
('email_suporte', 'raventech.suporte@gmail.com', 'E-mail de suporte'),
('telefone', '(88) 9217-43545', 'Telefone'),
('whatsapp', '(88) 9 2174-3545', 'WhatsApp');

-- Empresas Exemplo
INSERT INTO empresas (cnpj, razao_social, nome_fantasia, regime_tributario, cnae) VALUES 
('12.345.678/0001-90', 'Raven Tech Soluções Tecnológicas', 'Raven Tech', 'Lucro Presumido', '6201-5/01'),
('98.765.432/0001-01', 'Comércio Norte CE EIRELI', 'Comércio Norte', 'Simples Nacional', '4711-3/01'),
('11.222.333/0001-55', 'Indústria Fortaleza S/A', 'IndFor', 'Lucro Real', '1091-1/02');

-- Obrigações Fiscais
INSERT INTO calendario_fiscal (data, descricao, prazo_final, regime_tributario, tipo_obrigacao) VALUES 
(CURDATE(), 'Envio da EFD ICMS/IPI', DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Lucro Real', 'EFD ICMS/IPI'),
(DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'Entrega da ECF', DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'Todos', 'ECF'),
(DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Envio da GIA', DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'Simples Nacional', 'GIA');

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;