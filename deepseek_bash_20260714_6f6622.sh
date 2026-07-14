# Atualizar sistema
php update/update.php

# Backup manual
php cron/backup_automatico.php

# Restaurar backup
php cron/backup_restore.php backup.zip

# Verificar logs
tail -f logs/sistema.log

# Verificar versão
php -r "require 'config/constants.php'; echo SISTEMA_VERSAO;"