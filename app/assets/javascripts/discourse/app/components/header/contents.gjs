import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { service } from "@ember/service";
import { and } from "truth-helpers";
import BootstrapModeNotice from "../bootstrap-mode-notice";
import PluginOutlet from "../plugin-outlet";
import HomeLogo from "./home-logo";
import SidebarToggle from "./sidebar-toggle";
import TopicInfo from "./topic/info";

export default class Contents extends Component {
  @service site;
  @service currentUser;
  @service siteSettings;
  @service header;
  @service sidebarState;

  get sidebarIcon() {
    if (this.sidebarState.adminSidebarAllowedWithLegacyNavigationMenu) {
      return "discourse-sidebar";
    }

    return "bars";
  }

  <template>
    <div class="contents">
      <PluginOutlet
        @name="header-contents__before"
        @outletArgs={{hash
          topic=this.header.topic
          topicInfo=this.header.topicInfo
          topicInfoVisible=this.header.topicInfoVisible
        }}
      />
      {{#if this.site.desktopView}}
        {{#if @sidebarEnabled}}
          <SidebarToggle
            @toggleNavigationMenu={{@toggleNavigationMenu}}
            @showSidebar={{@showSidebar}}
            @icon={{this.sidebarIcon}}
          />
        {{/if}}
      {{/if}}

      <div class="home-logo-wrapper-outlet">
        <PluginOutlet @name="home-logo-wrapper">
          <HomeLogo @minimized={{this.header.topicInfoVisible}} />
        </PluginOutlet>
      </div>

      {{#if this.header.topicInfoVisible}}
        <TopicInfo @topic={{this.header.topicInfo}} />
      {{else if
        (and
          this.siteSettings.bootstrap_mode_enabled
          this.currentUser.staff
          this.site.desktopView
        )
      }}
        <div class="d-header-mode">
          <BootstrapModeNotice />
        </div>
      {{/if}}

      <div class="before-header-panel-outlet">
        <PluginOutlet
          @name="before-header-panel"
          @outletArgs={{hash
            topic=this.header.topic
            topicInfo=this.header.topicInfo
            topicInfoVisible=this.header.topicInfoVisible
          }}
        />
      </div>
      <div class="panel" role="navigation">{{yield}}</div>
      <div class="after-header-panel-outlet">
        <PluginOutlet
          @name="after-header-panel"
          @outletArgs={{hash
            topic=this.header.topic
            topicInfo=this.header.topicInfo
            topicInfoVisible=this.header.topicInfoVisible
          }}
        />
      </div>
      <PluginOutlet
        @name="header-contents__after"
        @outletArgs={{hash
          topic=this.header.topic
          topicInfo=this.header.topicInfo
          topicInfoVisible=this.header.topicInfoVisible
        }}
      />
    </div>
  </template>
}
