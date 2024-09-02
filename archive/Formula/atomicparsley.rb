class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210715.151551.e7ad03a.tar.gz"
  version "20210715.151551.e7ad03a"
  sha256 "546dcb5f3b625aff4f6bf22d27a0a636d15854fd729402a6933d31f3d0417e0d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/atomicparsley"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e619b04763cc062370e08dce74ce3b8947a80606c6a88e3bb1877d99b764a3cc"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
