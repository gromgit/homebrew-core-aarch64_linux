class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.5.12.tar.gz"
  sha256 "41bbcbde13c3a27696cb4ac0b9e752a925661747acc4075450e10d4e17b17bde"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fb78ea41c689b3deb0b24b017890b42b92fc373322f7237a4baccd4d518f6f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4dc330c83b25eec0d04c3ba88df0ca110e4a6239ec92364de09c7e000819e9"
    sha256 cellar: :any_skip_relocation, monterey:       "ea9013d42d48da14942c171f4b30b86d582e7580a73e72cdc668e5efaabacbe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ecfc33884b5066b51aef4f67a95d1060ab6c19791fd2570a127b82a95e940d2"
    sha256 cellar: :any_skip_relocation, catalina:       "f653a6e9519984f31ca451d0dfaf557cf9d68e45f8848eeea27d5222fcca7c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f94623ed185fe98292570e17756390b8fb10741c1a0296b8a9d7f8fa82a009"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
