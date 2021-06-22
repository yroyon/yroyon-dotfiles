" When ran via CoC, pylint fails to locate local modules.
" Solution:  have a .env file in the project root, containing:
" PYTHONPATH=".:pymldc"
" (listing your actual directories where you put your modules)

let b:coc_root_patterns = ['.git', '.env']
