class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.12.tar.gz"
  sha256 "64a59341424d30f8a87c71a19ffa775f8b56ad0d02b7820c6dd474f1a956165e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d5bad10063a17df635431c9662794c4c17f5ef71321b430303672e5e66f87d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48d5bad10063a17df635431c9662794c4c17f5ef71321b430303672e5e66f87d"
    sha256 cellar: :any_skip_relocation, monterey:       "b9886acfd72081084dffd53ea36ab45d2bb59fc15d21a8b680428574aef910cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9886acfd72081084dffd53ea36ab45d2bb59fc15d21a8b680428574aef910cc"
    sha256 cellar: :any_skip_relocation, catalina:       "b9886acfd72081084dffd53ea36ab45d2bb59fc15d21a8b680428574aef910cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8ae76e513cad4d9fc5b7157834ecb491b300ec0646800d8e0e8987de1b1bc2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
