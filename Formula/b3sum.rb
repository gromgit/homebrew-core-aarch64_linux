class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.1.tar.gz"
  sha256 "200587a49098957b5c119936ebee248cae4fb437827e444c7708e92ddf55836c"

  bottle do
    cellar :any_skip_relocation
    sha256 "242cb591b1c1508de78f07837eacfc3cfc998380475a96e2e55e0038ea0fa169" => :catalina
    sha256 "68f37fc80b6eaa9621f944548f76c43942d4bde6b54489e1b0c7577261d9b3fc" => :mojave
    sha256 "1bd0a9cddba682167b84e8ea52eaf1a5f3303ca477fd0bbcae75ade764a1acba" => :high_sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1000
  depends_on "rust" => :build

  def install
    if DevelopmentTools.clang_build_version <= 1000
      ENV["HOMEBREW_CC"] = "llvm_clang"
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    end
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./b3sum/"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
