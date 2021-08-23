#!/bin/bash
DIR="$HOME/.config/ssh_go"
DDIR="~/.config/ssh_go"
if [ ! -d "$DIR" ]; then
	mkdir -p "$DIR"
fi
if [ ! -f "$DIR/ips" ]; then
	touch "$DIR/ips"
	echo "Расположите IP-адреса построчно в файл \"$DDIR/ips\""
	echo "    в формате:"
	echo "user1@ip_address1:port|/путь/до/ключа(если есть)"
	echo "user2@ip_address2:port|/путь/до/ключа(если есть)"
	exit 0
fi
_test_() {
	local _good=0
	if [ -f "$DIR/commands" ]; then
		_good=1
	fi
	if [ -f "$DIR"/[0-9]* ]; then
		_good=1
	fi
	if [ "$_good" == 1 ]; then
		return 0
	else
		return 1
	fi
}
if ! _test_; then
	echo "Вы не создали файлы для команд, выполняемых на заданных серверах."
	echo "    поступить можно следующим образом:"
	echo "    1. Вы можете создать файл с командами индивидуально для каждого IP адреса"
	echo "    2. Вы можете создать файл с командами для всех IP адресов"
	echo "Для первого способа: создайте файл \"$DDIR/commands\" и пропишите туда все команды построчно"
	echo "Для второго способа: создайте файл с номером строки IP адреса, в котором для него будут выполняться команды"
	echo "    например, для сервера, находящегося первой строкой в файле \"$DDIR/ips\" нужно будет создать файл \"$DDIR/1\" и так далее..."
	echo ""
	echo "Выберите способ, создайте файл(ы) и запустите скрипт заново."
	exit 0
fi
if [ -z "$(< "$DIR"/ips)" ]; then
	echo "Файл \"$DDIR/ips\" пуст!"
	exit 1
fi
if [ ! -d "$DIR/history" ]; then
	mkdir -p "$DIR/history"
fi
echo "Вывод будет сохранён в $DDIR/history/IP_адрес"
_ls_() {
	_count=0
	for i in "$1"/*; do
		i="${i##*/}"
		[ "$i" == ssh_go ] && continue
		[ "$i" == commands ] & continue
		((_count++))
	done
}
#if [[ -f "$DIR/"[0-9]* ]]; then
#	_count_com="$(cat "$DIR/ips" | wc -l)"
#	_count_fls="$(_ls_ "$DIR")"
#	if [ "$_count_com" != "$_count_fls" ]; then
#		echo "Ошибка! Кол-во IP адресов не соотвутствует кол-ву файлов с командами!"
#		exit 1
#	fi
#fi
if [ -f "$DIR"/commands ]; then
	unset _key __key
	while read -r add <&3; do
		_user="${add%@*}"
		_ip="${add#*@}"
		_ip="${_ip%:*}"
		_port="${add#*:}"
		_port="${_port%|*}"
		_key="${add#*|}"
		_key="$(eval 'echo '$_key'')"
		if [ -n "$_key" ]; then
			__key="-i $_key"
		else
			unset __key
		fi
		echo -e "\e[1m===> Подключение к \e[1;33m$_ip\e[0m"
		ssh "${_user}@${_ip}" -p "$_port" $__key -t "$(echo 'rm -f /tmp/'$_ip''; cat "$DIR"/commands | sed 's/$/ &>>\/tmp\/'$_ip'/g')"
		echo -e "\e[1m===> Получение вывода команд с \e[1;33m$_ip\e[0m"
		scp $__key -P "$_port" "${user}@${_ip}":/tmp/${_ip} "$DIR/history/$_ip"
		echo -e "\e[1;32mГотово: \e[1;33m$_ip\e[0m"
	done 3< "$DIR"/ips
fi
if [ -f "$DIR"/[0-9]* ]; then
	unset _key __key
	_s_count=1
	while read -r add <&3; do
		_user="${add%@*}"
		_ip="${add#*@}"
		_ip="${_ip%:*}"
		_port="${add#*:}"
		_port="${_port%|*}"
		_key="${add#*|}"
		_key="$(eval 'echo '$_key'')"
		if [ -n "$_key" ]; then
			__key="-i $_key"
		else
			unset __key
		fi
		echo -e "\e[1m===> Подключение к \e[1;33m$_ip\e[0m\e[1m и выполнение заданных для него команд\e[0m"
		ssh "${_user}@${_ip}" -p "$_port" $__key -t "$(echo 'rm -f /tmp/'$_ip''; cat "$DIR"/$_s_count | sed 's/$/ &>>\/tmp\/'$_ip'/g')"
		echo -e "\e[1m===> Получение вывода команд с \e[1;33m$_ip\e[0m"
		scp $__key -P "$_port" "${user}@${_ip}":/tmp/${_ip} "$DIR/history/$_ip"
		echo -e "\e[1;32mГотово: \e[1;33m$_ip\e[0m"
		((_s_count++))
	done 3< "$DIR"/ips
fi
