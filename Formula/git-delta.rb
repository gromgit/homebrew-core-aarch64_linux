class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.9.1.tar.gz"
  sha256 "bb80c25d36ef4f185ec6439a06557339473e1ef4f12a706dcbacf8f8db2912b7"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28ece5de6c2416725624f0c9790e60c8fa0c1b6371d9ce5f77a8ca42fa3f6c3f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b686d57b5581ae6c7dc4c7640cac1b001dd85df9ad7569fff094b6436e3e16b"
    sha256 cellar: :any_skip_relocation, catalina:      "6966ef0b0120f420e8d9381783eab9f40cf52e28eda9294751849b1e1ca1d04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d56e3217ee40991fb5325595c98f6fc8a3f2fcca51737e973a80e045525bcfd"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
