Java:

Run script:

```bash
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash
```

En caso de que los parsers de treesitter den un error, eliminar los archivos resultantes de ejecutar el siguiente comando dentro de nvim:
```
:echo nvim_get_runtime_file('*/lua.so', v:true)
```
