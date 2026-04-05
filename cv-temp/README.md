# CV Staging Area

Put generated or alternative CV PDFs here.

Suggested workflow:

1. Run `bash scripts/build_cv.sh` to generate a timestamped PDF from `_pages/cv_tex.tex`.
2. Review the generated file in `cv-temp/`.
3. When you want to publish one version, copy it to `cv/JIAWEI_CV.pdf`.

Example:

```bash
cp "cv-temp/JIAWEI_CV-20260404.pdf" "cv/JIAWEI_CV.pdf"
```

The site only links to `cv/JIAWEI_CV.pdf`, so you can keep multiple variants here without changing any page content.
