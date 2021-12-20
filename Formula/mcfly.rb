class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.5.10.tar.gz"
  sha256 "57310e2b0c51a293223b6898b247ebad81da032650201fcf2943ec73e6817026"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87a80331cc0bcd4f12b120d4a3b56f4fbdb38a0b0ade2c53567160fda52121cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89ec399d5c6f2e421e155aadf6371c1f48360095ddd0f779b0984ad2ac1a2af"
    sha256 cellar: :any_skip_relocation, monterey:       "d796e0e4e3c657f9fd1e70be46a2aced985d1f5ec28137b469d1982246a6af38"
    sha256 cellar: :any_skip_relocation, big_sur:        "bed3aa51e4faa9aac608055ab6bbd7116a9456c5336ad946f5dc0217cdd0a01d"
    sha256 cellar: :any_skip_relocation, catalina:       "a94e9dfd4d32838fdf29fab47a4cd9d27ff084940d7ffe93f24d01df612806ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ebce6d0c84c0488fd517cbe49d4a080a249d3361800542a4fe8041d48fd8c1"
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
