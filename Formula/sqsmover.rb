class Sqsmover < Formula
  desc "AWS SQS Message mover"
  homepage "https://github.com/mercury2269/sqsmover"
  url "https://github.com/mercury2269/sqsmover/archive/v0.4.0.tar.gz"
  sha256 "217203f626399c67649f99af52eff6d6cdd9280ec5e2631e1de057e1bd0cdd0d"
  license "Apache-2.0"
  head "https://github.com/mercury2269/sqsmover.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sqsmover"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e998995037d8145b9f445572a2df765f32043d7c784c3aab2549eac1f65b356c"
  end

  depends_on "go" => :build

  # Fix build with Go 1.18.
  # Remove with the next release.
  patch do
    url "https://github.com/mercury2269/sqsmover/commit/2791c1912e4e262dca981dcf2219305b3d0e784a.patch?full_index=1"
    sha256 "effd7cc9422b64944abada78cbd163c8900b3dd1254427cbdee76e106e8e540b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    assert_match "Failed to resolve source queue.",
      shell_output("#{bin}/sqsmover --source test-dlq --destination test --profile test 2>&1")

    assert_match version.to_s, shell_output("#{bin}/sqsmover --version 2>&1")
  end
end
