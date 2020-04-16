class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/0.2.3.tar.gz"
  sha256 "e36ec947f89725e90e062eca39a8a8c88fdce4f83315ab942aa896627236421e"

  bottle do
    cellar :any
    sha256 "ef608bb9aca1f1ea62a17b677792756fb4e7d00c58630343f3104f76857bd329" => :catalina
    sha256 "78f6be95d9fb51354384daa626d9c6b04e018ecad09ba8c4e7f9d245808d38c8" => :mojave
    sha256 "3b889799f48267e17944f31c73d20baf43a71c4d8901b57ba3401c7c845bf091" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
