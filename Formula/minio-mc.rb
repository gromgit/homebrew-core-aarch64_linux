class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-01-16T02-45-34Z",
      revision: "f1f3003e5eddf7be07d03d2a83037dabb2c55e94"
  version "20210116024534"
  license "Apache-2.0"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f99f7fd964a7cd94ead6859bb6471bee9bd01bbf7f5b1ee4a29540d43af80d6a" => :big_sur
    sha256 "3fa1e4ce8c41145e617f2b261915c996e8b64a4c316b9404feb9b347dd077796" => :arm64_big_sur
    sha256 "2e5950ab321a1156dfa780e6e83c8da63a3ec4391cfd380fcff245d6a6e9e53b" => :catalina
    sha256 "69ca73389c6fbb26548660054d379a111982fdabd96683215cf4ff0fc64ae4f0" => :mojave
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
