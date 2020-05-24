class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.2.tar.xz"
  sha256 "8f3a63c8b68300dffe36f2e75eac57afa1e76d5d80af760fd138a0b3f44cf1e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac166e2e8a89dfa451a4abe531b31430fb6c3f5b386cf92f39b1a518837ff0ac" => :catalina
    sha256 "ac166e2e8a89dfa451a4abe531b31430fb6c3f5b386cf92f39b1a518837ff0ac" => :mojave
    sha256 "ac166e2e8a89dfa451a4abe531b31430fb6c3f5b386cf92f39b1a518837ff0ac" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-docs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spice/protocol.h>
      int main() {
        return (SPICE_LINK_ERR_OK == 0) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{include}/spice-1",
                   "-o", "test"
    system "./test"
  end
end
