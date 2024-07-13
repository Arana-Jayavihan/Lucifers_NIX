import { type BaseProps, type Widget } from "@ags/widgets/widget";

import Gtk from "gi://Gtk";

export type AspectFrameProps<
  Child extends Gtk.Widget = Gtk.Widget,
  Attr = unknown,
  Self = AspectFrame<Child, Attr>,
> = BaseProps<
  Self,
  Gtk.AspectFrame.ConstructorProperties & {
    child?: Child;
  },
  Attr
>;

export function newAspectFrame<
  Child extends Gtk.Widget = Gtk.Widget,
  Attr = unknown,
>(...props: ConstructorParameters<typeof AspectFrame<Child, Attr>>) {
  return new AspectFrame(...props);
}

export interface AspectFrame<Child, Attr> extends Widget<Attr> {}
export class AspectFrame<
  Child extends Gtk.Widget,
  Attr,
> extends Gtk.AspectFrame {
  static {
    Widget.register(this);
  }

  constructor(props: AspectFrameProps<Child, Attr> = {}) {
    super(props as Gtk.AspectFrame.ConstructorProperties);
  }

  get child() {
    return super.child as Child;
  }
  set child(child: Child) {
    super.child = child;
  }
}

export default AspectFrame;
