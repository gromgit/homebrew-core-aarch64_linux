class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd.git",
      tag:      "v21",
      revision: "2ce6095b2795052e34110599c484205468fb9fa6"
  license "BSD-2-Clause"
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    cellar :any
    sha256 "37f5ce56da71775cec3a8d1441a13d5f9ee8c3e903a3605867f46ca6452c8900" => :catalina
    sha256 "94eb461f5c5cbbadf1a3eec6c647ca34e9bf7897efe37c22c8f4c4eb045311e9" => :mojave
    sha256 "ec6bf6837faa5900e5e13380ea47b22d1ed317b0c4b7e7282d4c9b467ec1a125" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@1.1"

  patch do
    url "https://github.com/NeoRaider/fastd/commit/0d4045fb85d85903ebb9afe03a08d9b089300062.patch?full_index=1"
    sha256 "bb0d62e40575408497c6a285e6443c8386b4b85427463dd29df7736f3fe4ae9f"
  end

  def install
    mkdir "build" do
      system "meson", "-DENABLE_LTO=ON", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
