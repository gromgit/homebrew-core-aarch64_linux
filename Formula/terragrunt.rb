class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.8",
    :revision => "a3da7e3adb71fcbc18b964172f64a99aae6fa98c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6daaa42231cb0be985867eb8c4f474c8ecfd82874562ee4e97ff7e6df3707d41" => :catalina
    sha256 "a0595942c037045b637367ea61d2b00de5b497a879beb2adfe6d675684bb0399" => :mojave
    sha256 "16ff8cc7a021478863cb871534662772b2943dac7bd6e7ebd05247eaf021cb2e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
