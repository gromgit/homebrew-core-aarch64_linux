class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.0.1.tar.gz"
  sha256 "a45f0d55682e4f184efbe678d38d35c092ce72108ca550bce669c811fb0276ff"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 big_sur:  "c398259d9a89c8f220d8430ff564a7be4933b18d78037a24bc017240f0199099"
    sha256 catalina: "c5c2c646ab038f2086ed2814bc79992ae4ff8b9885af204e1bf1c167f0ad1903"
    sha256 mojave:   "fff4424d879c5b7f9e823e6c62484a84a1484ff08e451939cd2de87d3f55a72c"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared-mongoc"

    cd "src" do
      system "make"
      system "make", "install"
    end

    cd "tools" do
      system "make"
      system "make", "install"
    end
  end

  test do
    ENV.delete "CPATH"
    system bin/"tspawn", "new", "hello"
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?
      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
