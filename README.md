# Courses

李文朔的课程主页与教学资料 / Course websites and teaching materials by Wenshuo Li.

## 机器人操作 / Robotic Manipulation

- [中文主页](https://lwenshuo.github.io/courses/robotic-manipulation/)
- [English homepage](https://lwenshuo.github.io/courses/robotic-manipulation/en/)
- [课程目录 / Course directory](https://lwenshuo.github.io/courses/)

课件以 PDF 发布，程序以 ZIP 提供。现有课件与程序包说明为中文。
Slides are published as PDFs and code as ZIP archives. Current slides and bundled documentation are in Chinese.

## 机器人导航 / Robot Navigation

- [课程主页 / Course homepage](https://lwenshuo.github.io/courses/navigation/)
- [第一至第三周 PDF 课件](navigation/README.md)
- [Ref：参考资料、原作者引用与致谢](navigation/ref/README.md)

课程课件参考张虎（xiihoo）老师《机器人SLAM导航：核心技术与实战》及配套资料，感谢原作者的资源分享。

## Structure

- `robotic-manipulation/index.html`: Chinese course homepage
- `robotic-manipulation/en/index.html`: English course homepage
- `robotic-manipulation/materials/`: PDF slides, MATLAB archive, and supporting notes
- `navigation/index.html`: Robot Navigation course homepage
- `navigation/materials/`: Weekly PDF slides
- `navigation/ref/README.md`: Original sources and acknowledgements

## Publishing

GitHub Pages publishes the root of the `main` branch. `.nojekyll` enables plain static HTML hosting; no build dependencies are required.

To update materials, add PDFs or code archives to the materials directory, update both language pages, and push to `main`. Do not upload the source PowerPoint files.
