class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.11.4/QScintilla-2.11.4.tar.gz"
  sha256 "723f8f1d1686d9fc8f204cd855347e984322dd5cd727891d324d0d7d187bee20"
  revision 1

  bottle do
    cellar :any
    sha256 "d6bae2002c7d20b9db3b9d22411db1d2ea5a7391baeb4231ccecb71e8f983b3c" => :catalina
    sha256 "7ae90f4af154cdd22237db4f6679bf62165de120ca488594afd09902ff86bf38" => :mojave
    sha256 "2ba039eea909559f93920e34719f176e3cbaf5a7456dd5d816c86dcbc6333f9f" => :high_sierra
  end

  depends_on "pyqt"
  depends_on "python@3.8"
  depends_on "qt"
  depends_on "sip"

  def install
    spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
    args = %W[-config release -spec #{spec}]

    cd "Qt4Qt5" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", prefix/"trans"
        s.gsub! "$$[QT_INSTALL_DATA]", prefix/"data"
        s.gsub! "$$[QT_HOST_DATA]", prefix/"data"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system "qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    # Add qscintilla2 features search path, since it is not installed in Qt keg's mkspecs/features/
    ENV["QMAKEFEATURES"] = prefix/"data/mkspecs/features"

    cd "Python" do
      (share/"sip").mkpath
      version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
      pydir = "#{lib}/python#{version}/site-packages/PyQt5"
      system Formula["python@3.8"].opt_bin/"python3", "configure.py", "-o", lib, "-n", include,
                        "--apidir=#{prefix}/qsci",
                        "--destdir=#{pydir}",
                        "--stubsdir=#{pydir}",
                        "--qsci-sipdir=#{share}/sip",
                        "--qsci-incdir=#{include}",
                        "--qsci-libdir=#{lib}",
                        "--pyqt=PyQt5",
                        "--pyqt-sipdir=#{Formula["pyqt"].opt_share}/sip/Qt5",
                        "--sip-incdir=#{Formula["sip"].opt_include}",
                        "--spec=#{spec}",
                        "--no-dist-info"
      system "make"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import PyQt5.Qsci
      assert("QsciLexer" in dir(PyQt5.Qsci))
    EOS

    system Formula["python@3.8"].opt_bin/"python3", "test.py"
  end
end
