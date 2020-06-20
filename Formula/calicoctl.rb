class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.15.0",
      :revision => "7987fc57ae19d529c1289521f2e6371df90e2a4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "04dc66d4766dea86f16aee4a143f21a37018cb6817001b284d524ce387a471fa" => :catalina
    sha256 "48365fbe7b8370dc32ddfb1aedfa3bdcdb726191d3c6181753759c7c24bde8a1" => :mojave
    sha256 "5c40f73815cf4e977ecc9ce566481a4e5946af2fc419d8b1aa93850742df7c54" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
    system "go", "build", *std_go_args,
                          "-ldflags", "-X #{commands}.VERSION=#{stable.specs[:tag]} " \
                                      "-X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} " \
                                      "-s -w",
                          "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
