class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "0cddc2fb36a3a9c96ec94c0199e637a165eee3c86c6ab8cd6c3555cd3ae4c129"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cog"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d362992f08d301121240300606ed6fd21d7980b2ad05d4df09263160212e37bd"
  end

  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on "redis"

  def install
    args = %W[
      COG_VERSION=#{version}
      PYTHON=python3
    ]

    system "make", *args
    bin.install "cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
