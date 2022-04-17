class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.2.tar.gz"
  sha256 "d656587e416f8c5c8f15feed56b2162f8e4b4f591d91996c7001ffc5e981c53a"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce0bfd68e96e094669230f6ca60c791410c7ebfa12981dc706c5053523f4a6a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47389ebcc1222590b0551d18d1e126f519d861ae03214e1cb1632b5cea7f5c48"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f107d1dbeaf190c91d194e24073cf2fa77bd0947ca2264ac5a791f91dd3462"
    sha256 cellar: :any_skip_relocation, big_sur:        "7600728c9f6778e59bac60a56be7252c2efc399bb96c0faca85b80633e54168e"
    sha256 cellar: :any_skip_relocation, catalina:       "de23f479a230b663b6a41f87c4c433ad8c8e37da75812a6d2139af5485192ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b66e6ddc8e405cdeb659cabc2bd7a11d1407516373a8410bb4add65771db7ba"
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
