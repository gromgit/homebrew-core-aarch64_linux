class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.3.0.tar.gz"
  sha256 "3c83d7cb3e790afd62a5232956ca85378aa76b6e1d1875c921ead05b70bb0fa5"

  bottle do
    cellar :any
    sha256 "e01854fc98ba57c8a082f08f641279d8c85f2c1383593f6838d91b4b2ea62672" => :catalina
    sha256 "65fda02c202403e53abc8aef554369269a9225354bb0d3c5c4671b20777d1251" => :mojave
    sha256 "711ed4b4600fcb03d3d78c0aa42a453cf8f8918a6d3e856b948a6d2b3c79228a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lqxmpp
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <qxmpp/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
