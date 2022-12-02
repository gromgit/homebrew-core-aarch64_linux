class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.1.tar.gz"
  sha256 "7bb89df8c3b9de83e5a2272c18631c175f549d629c48d191968923490350caaf"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/autocorrect"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "abbe39b1c17ccaaf4ab1159ebe1d3ea3b799b4b55d51281900103ce1eb231709"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
