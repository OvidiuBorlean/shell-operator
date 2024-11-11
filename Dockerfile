FROM flant/shell-operator
ADD policy-hook.sh /hooks
RUN chmod +x /hooks/policy-hook.sh
