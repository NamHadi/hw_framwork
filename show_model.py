import spacy

def main():
    # Load the trained model
    try:
        nlp = spacy.load("models/model-best")
    except Exception as e:
        print("Error loading model. Ensure the model is trained and the path is correct.")
        print(str(e))
        return

    # sample sentences
    sentences = [
        "میرا نام نعیم ہے",
        " شفاف بنانے کے لئے زائد پولیس فورس تعینات کرنے کا مطالبہ کرتے ہوئے کہا کہ ان انتخابات ",
        "سٹر نائیڈو نے اپنے مکتوب مےں چیف الیکشن کمشنر سے خواہش کی کہ وہ ہر حلقہ اسمبلی مےں علحدہ علحدہ فورس کی تعیناتی کو یقینی بنانے کے اقدامات کریں تاکہ آزادانہ و منصفانہ انتخابات کو یقینی بنایا جا سکے"
    ]

    # Process and display results
    for sentence in sentences:
        doc = nlp(sentence)
        print(f"Sentence: {sentence}")
        print("Tokens and Predictions:")
        for token in doc:
            print(f"  {token.text:15} AG: {token.tag_}")
        print("-" * 40)


if __name__ == "__main__":
    main()
