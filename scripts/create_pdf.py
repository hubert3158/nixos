from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

def create_pdf():
    c = canvas.Canvas("example.pdf", pagesize=letter)
    c.drawString(100, 750, "Hello, World!")
    c.save()

if __name__ == "__main__":
    create_pdf()
