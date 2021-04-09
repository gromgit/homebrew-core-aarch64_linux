class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.71.tar.gz"
  sha256 "c9b1fbc5190bcf83a16f01dbbc7a819ce0191ebe371769133177ca2fa5c42d31"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96b27f48cb3af455d1cf1cb55f1937cd57cdd2547b553071033220f0dbdfcc19"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a5a7b82d5333a28928ec3db6f6e4237aac7da03e130f60e432178dcdc1d4434"
    sha256 cellar: :any_skip_relocation, catalina:      "703588356d6c5f2858d2b188662b154fca3241bd87dedb80608ffb5621af8039"
    sha256 cellar: :any_skip_relocation, mojave:        "05813ca207189c09603c4b763bfd6cef2ccda537c37b642e136b8e24f4d9f5cc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
