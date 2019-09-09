## Shared

These are ports that must be compiled dynamically.

----

### Example: 

Imlib2 works by dlopening its plugins.
Any program depending on Imlib2, must then
also be shared as well...

(***NOTE:*** *I COULD BE WRONG*, there could be a patchable solution)

----

If you find a way to get any of these ports to be static,
please pull request and let me know.
