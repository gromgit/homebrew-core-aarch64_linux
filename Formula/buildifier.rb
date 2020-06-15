class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "3.2.1",
      :revision => "a60df6e5d134ed103669f206ad74ec2154f1a562"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b49beb32628d1ecbbe85abe6b837533e12febfccffffd28b9a4c3cb2b35e960" => :catalina
    sha256 "2b49beb32628d1ecbbe85abe6b837533e12febfccffffd28b9a4c3cb2b35e960" => :mojave
    sha256 "2b49beb32628d1ecbbe85abe6b837533e12febfccffffd28b9a4c3cb2b35e960" => :high_sierra
  end

  depends_on "bazelisk" => :build

  def install
    system "bazelisk", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
