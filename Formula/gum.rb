class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.5.0.tar.gz"
  sha256 "0f8e071cc3610c641cc0539f7feb9652b0e8a1fa8f7409c81625cbe71027f28e"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b748649baae6755c3de917806a73ba69a42f7a09b53a654b5efddb1a8f4f7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "011b450b24ca1bf0b680e98dd077559f20234491b964721a17dbc7e114149399"
    sha256 cellar: :any_skip_relocation, monterey:       "1478c990e82a999e83445136a675a93fa97c8e58ae590a394532e04fbf979223"
    sha256 cellar: :any_skip_relocation, big_sur:        "a031b826537fbd4933b0efddedfc80e4e70ae79369dfd9334fcfc483deec0dcc"
    sha256 cellar: :any_skip_relocation, catalina:       "1b36841f2010be83850abd922e06e302d6297d547984b92052b976c124533e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adae271b7a30519dc3810977fd6e75563ce966ecc601adaf3543a04b869f8052"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    bash_output = Utils.safe_popen_read(bin/"gum", "completion", "bash")
    (bash_completion/"gum").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gum", "completion", "zsh")
    (zsh_completion/"_gum").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gum", "completion", "fish")
    (fish_completion/"gum.fish").write fish_output
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
