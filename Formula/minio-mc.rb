class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-07-17T02-52-20Z",
      revision: "f19a10dce2ab5a0fbc8c0ff63cf8e4b4572ad582"
  version "20200717025220"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "72024daa663c09ade1993372bcf1913d010b4a68f0d771271daa9571bbd46572" => :catalina
    sha256 "b220d65df41586c21354543690c8b8b5081b0f57679af20c56f5427bf358a841" => :mojave
    sha256 "fddc39ea96fd68b2bef0a8efbd493725503ecc7ed676924963a6d34e787c2af5" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
