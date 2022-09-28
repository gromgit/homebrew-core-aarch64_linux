class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.55.1.tar.gz"
  sha256 "5f76c3457bde03f334144cda90dee0570705af338a6b960f8ff6edfebad541ea"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c70bc3355631bc3f079ad70039426c5bb7d832ba24b7f1b69a05d186d285a72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e36ee96fbe80f2ce9ad2b3f84927021618adb49b0455ebc092863381cba7e563"
    sha256 cellar: :any_skip_relocation, monterey:       "60d32a18100a9f253a41c22169dd41aae787fe698acd191fb8a2b636dd1460dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "151442b03f4066b26d6fcf24925858a1af4b527b07c6c973ac3d5343a0e71cd3"
    sha256 cellar: :any_skip_relocation, catalina:       "317fada567f76b13dea48c8a09d4376fd5912595b2d5d8442112c3af4ff7d5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1232b4a6eadf5fd2fd3ea98005790e5d524011e990f988fac0c51d2ff67c7929"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
