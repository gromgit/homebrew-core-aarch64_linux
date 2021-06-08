class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-06-08T01-29-37Z",
      revision: "c8d9eee2b4e4984a934656eaf6d3f8de0899450b"
  version "20210608012937"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb5c45c26f5f31fcd8cb950b4c99978af3b9aae77de2d7fcfbf31d38e5066658"
    sha256 cellar: :any_skip_relocation, big_sur:       "76e87277688b6d8b5ade176e502222e78ec7939cc963f1c62014a3c0ba339a66"
    sha256 cellar: :any_skip_relocation, catalina:      "e7d898b23268a293f6feaed29bdd0a75014178a9b04f0d1bf9d491d41d56c9ee"
    sha256 cellar: :any_skip_relocation, mojave:        "5b3307a9656145f2b75fe82eb3fbfdb06ba4daac05ee923184a1ca3da10de419"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
