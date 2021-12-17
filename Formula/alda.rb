class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.0.7.tar.gz"
  sha256 "38c4ef58ab1f7173733fa50b6c5dc6e9f1260c25678cce93fd5b3908e0aab8d6"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02757ef96e556ed4d32a47ba2ee26a5496fb113655809990d06ebefe5e0b8a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f414c87e54c90053cf0e7a1275191e4be27f0416bbd34ca6112cc6c11c4e92b"
    sha256 cellar: :any_skip_relocation, monterey:       "501b762db038093de5aa2243bc72f4add49335985a12c569aba9712cf1601f6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "225e7ead2ae87475a61894704797115fbf16b26f6dd4bddc2719eb0a7f68a605"
    sha256 cellar: :any_skip_relocation, catalina:       "d4937352087714a1d827336b26cf5f47b7f1a6a2358224d3c0345451d8ff7eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827d2c725509840db85b71f91bd384fb8b27165e35542873caf1ece16519c74d"
  end

  depends_on "go" => :build
  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "build/libs/alda-player-fat.jar"
      bin.write_jar_script libexec/"alda-player-fat.jar", "alda-player"
    end
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end
