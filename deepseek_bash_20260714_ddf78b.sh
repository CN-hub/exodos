#!/bin/bash
# ============================================
# ÊXODO - DEPLOY AUTOMÁTICO
# Sistema de Controle Fiscal
# 
# Desenvolvido por: Cleilton Nascimento - CEO
# Copyright © 2026 Raven Tech - Todos os direitos reservados
# ============================================

echo "╔══════════════════════════════════════════════════════════╗"
echo "║                     ⚡ ÊXODO                            ║"
echo "║            Sistema de Controle Fiscal                   ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Desenvolvido por: Cleilton Nascimento - CEO            ║"
echo "║  Copyright © 2026 Raven Tech - Todos os direitos        ║"
echo "║  LOCALIZAÇÃO: Juazeiro do Norte - Ceará                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configurações
PROJECT_NAME="exodo"
PROJECT_PATH="/var/www/${PROJECT_NAME}"
DOMAIN="seudominio.com.br"
ADMIN_EMAIL="raventech.suporte@gmail.com"

echo -e "${BLUE}🚀 Iniciando deploy do Êxodo...${NC}"

# Verificar se é root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Execute como root (sudo su)${NC}"
    exit 1
fi

# 1. Atualizar sistema
echo -e "${YELLOW}📦 Atualizando sistema...${NC}"
apt update && apt upgrade -y

# 2. Instalar dependências
echo -e "${YELLOW}📦 Instalando dependências...${NC}"
apt install -y apache2 mysql-server php php-cli php-common \
    php-mysql php-zip php-gd php-mbstring php-curl php-xml \
    php-bcmath php-intl php-imagick git curl unzip \
    certbot python3-certbot-apache composer -y

# 3. Configurar PHP
echo -e "${YELLOW}⚙️ Configurando PHP...${NC}"
cat > /etc/php/8.1/apache2/conf.d/99-exodo.ini <<EOF
upload_max_filesize = 100M
post_max_size = 100M
memory_limit = 512M
max_execution_time = 3600
date.timezone = America/Fortaleza
expose_php = Off
display_errors = Off
log_errors = On
error_log = /var/log/php_errors.log
EOF

# 4. Criar diretório do projeto
echo -e "${YELLOW}📁 Criando diretório do projeto...${NC}"
mkdir -p $PROJECT_PATH
cd $PROJECT_PATH

# 5. Baixar código (ajuste conforme necessário)
echo -e "${YELLOW}📥 Baixando código fonte...${NC}"
# Se tiver repositório git:
# git clone https://github.com/ravetech/exodo.git .

# Ou copiar manualmente os arquivos (via SCP/FTP)
echo -e "${YELLOW}⚠️ Copie os arquivos do sistema para: ${PROJECT_PATH}${NC}"
echo -e "${YELLOW}   Exemplo: scp -r ./exodo/* root@seu-ip:${PROJECT_PATH}/${NC}"
echo ""
read -p "Pressione ENTER após copiar os arquivos..."

# 6. Configurar permissões
echo -e "${YELLOW}🔧 Configurando permissões...${NC}"
chown -R www-data:www-data $PROJECT_PATH
chmod -R 755 $PROJECT_PATH
chmod -R 775 $PROJECT_PATH/backups $PROJECT_PATH/uploads $PROJECT_PATH/logs

# 7. Configurar .env
echo -e "${YELLOW}📝 Configurando ambiente...${NC}"
if [ ! -f "$PROJECT_PATH/.env" ]; then
    cp $PROJECT_PATH/.env.example $PROJECT_PATH/.env
    echo -e "${RED}⚠️ Edite o arquivo .env com suas configurações:${NC}"
    echo "   nano $PROJECT_PATH/.env"
    read -p "Pressione ENTER após editar..."
fi

# 8. Instalar dependências PHP
echo -e "${YELLOW}📦 Instalando dependências PHP...${NC}"
cd $PROJECT_PATH
composer install --no-dev

# 9. Configurar banco de dados
echo -e "${YELLOW}🗄️ Configurando banco de dados...${NC}"
mysql -e "CREATE DATABASE IF NOT EXISTS exodo_fiscal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql exodo_fiscal < $PROJECT_PATH/config/database_full.sql

# 10. Configurar Apache
echo -e "${YELLOW}🌐 Configurando Apache...${NC}"
cat > /etc/apache2/sites-available/exodo.conf <<EOF
<VirtualHost *:80>
    ServerAdmin ${ADMIN_EMAIL}
    ServerName ${DOMAIN}
    DocumentRoot ${PROJECT_PATH}
    
    <Directory ${PROJECT_PATH}>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/exodo-error.log
    CustomLog \${APACHE_LOG_DIR}/exodo-access.log combined
    
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "DENY"
    Header always set X-XSS-Protection "1; mode=block"
</VirtualHost>
EOF

# 11. Ativar site
echo -e "${YELLOW}🔧 Ativando site...${NC}"
a2ensite exodo.conf
a2enmod rewrite headers
systemctl restart apache2

# 12. Configurar SSL
echo -e "${YELLOW}🔒 Configurando SSL (Let's Encrypt)...${NC}"
certbot --apache -d ${DOMAIN} --non-interactive \
    --agree-tos --email ${ADMIN_EMAIL}

# 13. Configurar Cron
echo -e "${YELLOW}⏰ Configurando backup automático...${NC}"
(crontab -l 2>/dev/null | grep -v "backup_automatico.php"; 
 echo "0 2 * * * php ${PROJECT_PATH}/cron/backup_automatico.php") | crontab -

# 14. Criar arquivo de versão
echo -e "${YELLOW}📝 Criando arquivo de versão...${NC}"
cat > $PROJECT_PATH/config/versao.json <<EOF
{
    "versao": "1.0.0",
    "codigo": "$(date +%Y%m%d)",
    "nome": "Êxodo - Sistema de Controle Fiscal",
    "data": "$(date '+%Y-%m-%d %H:%M:%S')",
    "desenvolvido_por": "Cleilton Nascimento - CEO",
    "copyright": "© $(date +%Y) Raven Tech - Todos os direitos reservados"
}
EOF

# 15. Finalizar
echo ""
echo -e "${GREEN}✅ Deploy concluído com sucesso!${NC}"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  ⚡ ÊXODO - Sistema de Controle Fiscal"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo -e "🌐 Acesse: ${GREEN}https://${DOMAIN}${NC}"
echo -e "📧 E-mail: ${GREEN}${ADMIN_EMAIL}${NC}"
echo -e "📱 WhatsApp: ${GREEN}(88) 9 2174-3545${NC}"
echo -e "👨‍💼 CEO: ${GREEN}Cleilton Nascimento${NC}"
echo ""
echo "📌 Credenciais padrão:"
echo -e "   Usuário: ${YELLOW}admin@exodo.com.br${NC}"
echo -e "   Senha: ${YELLOW}123456${NC}"
echo -e "   ${RED}⚠️ ALTERE A SENHA IMEDIATAMENTE!${NC}"
echo ""
echo "📂 Diretório do projeto: ${PROJECT_PATH}"
echo "📁 Backups: ${PROJECT_PATH}/backups"
echo "📁 Logs: ${PROJECT_PATH}/logs"
echo ""
echo -e "${BLUE}💡 Comandos úteis:${NC}"
echo "   - Atualizar sistema: php ${PROJECT_PATH}/update/update.php"
echo "   - Backup manual: php ${PROJECT_PATH}/cron/backup_automatico.php"
echo "   - Ver logs: tail -f ${PROJECT_PATH}/logs/sistema.log"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "⚡ ÊXODO - Liberdade e eficiência na gestão fiscal"
echo "📌 Desenvolvido por: Cleilton Nascimento - CEO"
echo "📌 Copyright © $(date +%Y) Raven Tech - Todos os direitos reservados"
echo "═══════════════════════════════════════════════════════════"