class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.10.2.tar.gz"
  sha256 "7cd91a244cb330cda5b41f4904f94b61f39ba112835b31fa8c3764cedbed819f"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "082b9e9538d5edd7757b0365d2661862cbb0c72b8a673d90595b9bab82ac8a55"
    sha256 arm64_big_sur:  "5e323e78ea4dcb77095c408bb66edcae2709f087225d40d5c3d49be64249ed9a"
    sha256 monterey:       "c481ae927ef7c4fc42ded6c265e65d41a676abe459923d2265f5ea1af2ce0be8"
    sha256 big_sur:        "fe5ea65e9885cf41986d70ca90f1e2ff9f8ffdd631d97047003af60889e8c7f6"
    sha256 catalina:       "8fbf305bd1ee071768784f6f6797dc6116d2eda34d96aa2278b9cb2675c1230a"
    sha256 x86_64_linux:   "9c647ac6b614b8a20aeb785c16ec9977231c05c0cfc13d0425b3beb9b749d15f"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write shell_output("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
