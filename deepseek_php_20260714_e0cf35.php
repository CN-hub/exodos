<?php
/**
 * ÊXODO - SISTEMA DE CONTROLE FISCAL
 * 
 * Desenvolvido por: Cleilton Nascimento - CEO
 * Copyright © 2026 Raven Tech Soluções Tecnológicas
 * Todos os direitos reservados.
 * 
 * LOCALIZAÇÃO: Juazeiro do Norte - Ceará
 * ESCRITÓRIO DIGITAL
 */

require_once 'config/constants.php';
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= SISTEMA_NOME_COMPLETO ?> | <?= RAVETECH_NOME ?></title>
    <meta name="description" content="<?= SISTEMA_DESCRICAO ?> - <?= RAVETECH_NOME ?>">
    <meta name="author" content="<?= RAVETECH_CEO ?>">
    <meta name="copyright" content="<?= RAVETECH_COPYRIGHT ?>">
    
    <!-- Open Graph -->
    <meta property="og:title" content="<?= SISTEMA_NOME_COMPLETO ?>">
    <meta property="og:description" content="<?= SISTEMA_DESCRICAO ?>">
    <meta property="og:type" content="website">
    <meta property="og:url" content="<?= RAVETECH_WEBSITE ?>">
    
    <!-- Favicon -->
    <link rel="icon" href="/assets/images/favicon.ico" type="image/x-icon">
    
    <!-- CSS -->
    <link rel="stylesheet" href="/assets/css/temas.css">
    <link rel="stylesheet" href="/assets/css/ravetech-brand.css">
    
    <style>
        .hero-exodo {
            background: linear-gradient(135deg, #0A2647 0%, #1B4F72 50%, #2980B9 100%);
            color: white;
            padding: 80px 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-exodo::before {
            content: '⚡';
            position: absolute;
            font-size: 300px;
            opacity: 0.05;
            right: -50px;
            top: -50px;
        }
        
        .hero-exodo .content {
            position: relative;
            z-index: 1;
        }
        
        .hero-exodo .logo-icon {
            font-size: 80px;
            margin-bottom: 20px;
            display: block;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }
        
        .hero-exodo h1 {
            font-size: 56px;
            font-weight: 800;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #FFFFFF 0%, #F39C12 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -2px;
        }
        
        .hero-exodo .subtitle {
            font-size: 22px;
            opacity: 0.9;
            -webkit-text-fill-color: white;
            font-weight: 300;
        }
        
        .hero-exodo .frase {
            font-size: 16px;
            opacity: 0.7;
            margin-top: 10px;
            font-style: italic;
            -webkit-text-fill-color: rgba(255,255,255,0.7);
        }
        
        .hero-exodo .version-badge {
            display: inline-block;
            background: rgba(243, 156, 18, 0.2);
            border: 1px solid #F39C12;
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 13px;
            margin-top: 15px;
            -webkit-text-fill-color: #F39C12;
        }
        
        .hero-exodo .ceo-info {
            margin-top: 20px;
            font-size: 14px;
            opacity: 0.6;
            -webkit-text-fill-color: white;
        }
        
        .hero-exodo .ceo-info strong {
            color: #F39C12;
            -webkit-text-fill-color: #F39C12;
        }
        
        .hero-exodo .btn-acessar {
            display: inline-block;
            margin-top: 30px;
            padding: 14px 50px;
            background: linear-gradient(135deg, #F39C12, #E67E22);
            color: white;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 18px;
            transition: all 0.3s;
            -webkit-text-fill-color: white;
            box-shadow: 0 4px 20px rgba(243, 156, 18, 0.3);
        }
        
        .hero-exodo .btn-acessar:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 30px rgba(243, 156, 18, 0.5);
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: -30px auto 40px;
            padding: 0 20px;
            position: relative;
            z-index: 2;
        }
        
        .feature-card {
            background: var(--bg-card);
            padding: 25px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            text-align: center;
            border-top: 4px solid var(--primary);
            transition: all 0.3s;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }
        
        .feature-card .icon {
            font-size: 36px;
            margin-bottom: 10px;
            display: block;
        }
        
        .feature-card h3 {
            font-size: 16px;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        
        .feature-card p {
            font-size: 13px;
            color: var(--text-secondary);
            margin: 0;
        }
        
        .portais-rapidos {
            max-width: 1200px;
            margin: 0 auto 40px;
            padding: 0 20px;
        }
        
        .portais-rapidos h2 {
            text-align: center;
            margin-bottom: 20px;
            color: var(--text-primary);
        }
        
        .portais-grid-rapidos {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px;
        }
        
        .portal-link {
            background: var(--bg-card);
            padding: 12px 15px;
            border-radius: 8px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: var(--shadow);
            transition: all 0.3s;
            border: 1px solid var(--border-light);
        }
        
        .portal-link:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .portal-link .portal-icon {
            font-size: 20px;
        }
        
        .portal-link .portal-name {
            font-size: 12px;
            font-weight: 500;
            color: var(--text-primary);
        }
        
        @media (max-width: 768px) {
            .hero-exodo h1 { font-size: 36px; }
            .hero-exodo .subtitle { font-size: 18px; }
            .features-grid { margin-top: -20px; }
            .portais-grid-rapidos { grid-template-columns: repeat(2, 1fr); }
        }
        
        @media (max-width: 480px) {
            .hero-exodo h1 { font-size: 28px; }
            .hero-exodo .subtitle { font-size: 15px; }
            .portais-grid-rapidos { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="ravetech-header">
        <div class="brand">
            <div class="logo">
                ⚡ <span class="highlight">ÊXODO</span>
            </div>
            <div class="subtitle">
                Sistema de Controle Fiscal
            </div>
        </div>
        <div class="header-right">
            <span class="ravetech-badge">
                <span class="icon">💻</span>
                <?= RAVETECH_TIPO ?>
            </span>
            <span style="font-size: 11px; opacity: 0.6; color: white;">
                v<?= SISTEMA_VERSAO ?>
            </span>
        </div>
    </header>
    
    <!-- Hero -->
    <section class="hero-exodo">
        <div class="content">
            <span class="logo-icon">⚡</span>
            <h1>ÊXODO</h1>
            <p class="subtitle"><?= SISTEMA_DESCRICAO ?></p>
            <p class="frase">"<?= SISTEMA_FRASE ?>"</p>
            <div class="version-badge">
                Versão <?= SISTEMA_VERSAO ?> · <?= date('d/m/Y') ?>
            </div>
            <div class="ceo-info">
                <strong>© <?= date('Y') ?> <?= RAVETECH_NOME ?></strong><br>
                Desenvolvido por <strong><?= RAVETECH_CEO ?></strong> - <?= RAVETECH_CARGO ?>
            </div>
            <a href="/login/" class="btn-acessar">
                🔐 Acessar Sistema
            </a>
        </div>
    </section>
    
    <!-- Features -->
    <div class="features-grid">
        <div class="feature-card">
            <span class="icon">📊</span>
            <h3>Gestão Fiscal</h3>
            <p>Controle completo de empresas e obrigações fiscais</p>
        </div>
        <div class="feature-card">
            <span class="icon">📅</span>
            <h3>Calendário Fiscal</h3>
            <p>Feriados e prazos automáticos para Juazeiro do Norte</p>
        </div>
        <div class="feature-card">
            <span class="icon">✍️</span>
            <h3>Assinatura Digital</h3>
            <p>Assine documentos com certificado ICP-Brasil</p>
        </div>
        <div class="feature-card">
            <span class="icon">💾</span>
            <h3>Backup Automático</h3>
            <p>Backup diário com retenção de 30 dias</p>
        </div>
    </div>
    
    <!-- Portais Rápidos -->
    <div class="portais-rapidos">
        <h2>🌐 Acesso Rápido aos Portais</h2>
        <div class="portais-grid-rapidos">
            <a href="https://www.gov.br/receitafederal" target="_blank" class="portal-link">
                <span class="portal-icon">🏛️</span>
                <span class="portal-name">Receita Federal</span>
            </a>
            <a href="https://www.sefaz.ce.gov.br" target="_blank" class="portal-link">
                <span class="portal-icon">⚖️</span>
                <span class="portal-name">SEFAZ-CE</span>
            </a>
            <a href="https://www.sintegra.gov.br" target="_blank" class="portal-link">
                <span class="portal-icon">🔍</span>
                <span class="portal-name">Sintegra</span>
            </a>
            <a href="https://www.redesim.gov.br" target="_blank" class="portal-link">
                <span class="portal-icon">🏢</span>
                <span class="portal-name">Redesim</span>
            </a>
            <a href="https://www.nfe.fazenda.gov.br" target="_blank" class="portal-link">
                <span class="portal-icon">📄</span>
                <span class="portal-name">Portal NFe</span>
            </a>
            <a href="https://www.gov.br" target="_blank" class="portal-link">
                <span class="portal-icon">🇧🇷</span>
                <span class="portal-name">Gov.br</span>
            </a>
        </div>
    </div>
    
    <!-- Footer -->
    <?php include 'includes/footer_juazeiro.php'; ?>
    
    <!-- Scripts -->
    <script src="/assets/js/init.js"></script>
</body>
</html>